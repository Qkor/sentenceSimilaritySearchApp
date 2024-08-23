import 'package:objectbox/objectbox.dart';

@Entity()
class Paragraph{
  @Id()
  int id = 0;
  String text;
  @HnswIndex(dimensions: 384)
  @Property(type: PropertyType.floatVector)
  List<double>? embedding;

  Paragraph({required this.embedding, required this.text});
}