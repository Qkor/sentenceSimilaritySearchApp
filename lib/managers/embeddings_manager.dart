import 'package:flutter/services.dart';
import 'package:rag/managers/tokenizer.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:collection/collection.dart';

class EmbeddingsManager {
  static const _assetFileName = 'assets/models/model.onnx';
  static final tokenizer = Tokenizer();
  static OrtSessionOptions? _sessionOptions;
  static OrtSession? _session;

  static initModel() async {
    await tokenizer.loadTokenizer();
    OrtEnv.instance.init();
    _sessionOptions = OrtSessionOptions();
    var rawAssetFile = await rootBundle.load(_assetFileName);
    var bytes = rawAssetFile.buffer.asUint8List();
    _session = OrtSession.fromBuffer(bytes, _sessionOptions!);
  }

  static release(){
    _session?.release();
    OrtEnv.instance.release();
  }

  static List<List<double>> _inference(List<int> wordIds, List<int> attentionMask){
    final inputShape = [1,wordIds.length];
    final inputIdsOrt = OrtValueTensor.createTensorWithDataList(wordIds, inputShape);
    final inputMaskOrt = OrtValueTensor.createTensorWithDataList(attentionMask, inputShape);
    final inputs = {'input_ids': inputIdsOrt, 'attention_mask': inputMaskOrt};
    final runOptions = OrtRunOptions();
    final outputs = _session!.run(runOptions, inputs);
    final embeddingsTensor = outputs[0]!.value;
    final embeddingsBatch = embeddingsTensor as List<List<List<double>>>;
    List<List<double>> wordEmbeddings = embeddingsBatch[0];
    for (var element in outputs) {
      element?.release();
    }
    inputIdsOrt.release();
    inputMaskOrt.release();
    runOptions.release();
    return wordEmbeddings;
  }

  static List<double> _meanPooling(List<List<double>> wordEmbeddings, List<int> attentionMask){
    final embeddingsSize = wordEmbeddings[0].length;
    List<double> sentenceEmbeddings = List.filled(embeddingsSize, 0.0);
    for(var i=0;i<wordEmbeddings.length;i++){
      if(attentionMask[i] == 1){
        for(var j=0;j<embeddingsSize;j++){
          sentenceEmbeddings[j] += wordEmbeddings[i][j];
        }
      }
    }
    return sentenceEmbeddings.map((e) => e/attentionMask.sum).toList();
  }

  static List<double> encode(String text) {
    final tokens = tokenizer.encode(text);
    final attentionMask = List.filled(tokens.length, 1);
    final wordEmbeddings = _inference(tokens, attentionMask);
    return _meanPooling(wordEmbeddings, attentionMask);
  }
}