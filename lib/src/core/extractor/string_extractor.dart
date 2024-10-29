class StringExtractor {
  static String? extract({
    required String start,
    required String end,
    required String terminalOutput,
  }) {
    // Build the regex pattern dynamically
    start = "lane_output_start${start}";
    end = "${end}lane_output_end";
    String pattern = '${RegExp.escape(start)}(.*?)${RegExp.escape(end)}';

    // Define a regular expression to match the pattern
    RegExp regExp = RegExp(pattern);

    // Use the regular expression to find the match
    Match? match = regExp.firstMatch(terminalOutput);

    // Extract the value
    String? extractedValue = match?.group(1);
    return extractedValue;
  }
}
