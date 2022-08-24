
truncateString(str, int num) {
    if (str.length > num) {
      String  subStr = str.substring(0, num);
        return "$subStr...";
    } else {
        return str;
    }
  }