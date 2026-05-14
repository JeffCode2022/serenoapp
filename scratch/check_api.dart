
import 'package:file_picker/file_picker.dart';

void main() async {
  FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
  );
}
