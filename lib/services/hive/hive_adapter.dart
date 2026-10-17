import 'package:hive_ce/hive_ce.dart';
import '../../model/link_model.dart'; // Adjust path if needed

part 'hive_adapter.g.dart';

@GenerateAdapters([
  AdapterSpec<LinkItem>(),
])
void main() {}