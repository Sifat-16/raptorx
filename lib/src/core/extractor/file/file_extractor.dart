import 'dart:convert';
import 'dart:io';

class FileExtractor {
  static Future<T> extractDataFromFile<T>(
      {required File file, required T Function(dynamic json) extractor}) async {
    // Read the JSON file
    String jsonContent = await file.readAsString();
    // Decode the JSON and create a TRexModel instance
    Map<String, dynamic> jsonData = jsonDecode(jsonContent);
    return extractor(jsonData);
  }
}
