
  factory Table.fromTextArray({
    Context context,//
    @required List<List<dynamic>> data,//
    EdgeInsets cellPadding = const EdgeInsets.all(5),
    double cellHeight = 0,
    Alignment cellAlignment = Alignment.topLeft,
    Map<int, Alignment> cellAlignments,
    TextStyle cellStyle,
    TextStyle oddCellStyle,
    OnCellFormat cellFormat,
    int headerCount = 1,
    List<dynamic> headers,
    EdgeInsets headerPadding,
    double headerHeight,
    Alignment headerAlignment = Alignment.center,
    Map<int, Alignment> headerAlignments,
    TextStyle headerStyle,
    OnCellFormat headerFormat,
    TableBorder border = const TableBorder(
      left: BorderSide(),
      right: BorderSide(),
      top: BorderSide(),
      bottom: BorderSide(),
      horizontalInside: BorderSide(),
      verticalInside: BorderSide(),
    ),
    Map<int, TableColumnWidth> columnWidths,
    TableColumnWidth defaultColumnWidth = const IntrinsicColumnWidth(),
    TableWidth tableWidth = TableWidth.max,
    BoxDecoration headerDecoration,
    BoxDecoration rowDecoration,
    BoxDecoration oddRowDecoration,
  }) {
    assert(data != null);
    assert(headerCount != null && headerCount >= 0);
    assert(cellHeight != null);

    if (context != null) {
      final theme = Theme.of(context);
      headerStyle ??= theme.tableHeader;
      cellStyle ??= theme.tableCell;
    }

    headerPadding ??= cellPadding;
    headerHeight ??= cellHeight;
    oddRowDecoration ??= rowDecoration;
    oddCellStyle ??= cellStyle;
    cellAlignments ??= const <int, Alignment>{};
    headerAlignments ??= cellAlignments;

    final rows = <TableRow>[];

    var rowNum = 0;
    if (headers != null) {
      final tableRow = <Widget>[];

      for (final dynamic cell in headers) {
        tableRow.add(
          Container(
            alignment: headerAlignments[tableRow.length] ?? headerAlignment,
            padding: headerPadding,
            constraints: BoxConstraints(minHeight: headerHeight),
            child: Text(
              headerFormat == null
                  ? cell.toString()
                  : headerFormat(tableRow.length, cell),
              style: headerStyle,
            ),
          ),
        );
      }
      rows.add(TableRow(
        children: tableRow,
        repeat: true,
        decoration: headerDecoration,
      ));
      rowNum++;
    }

    for (final row in data) {
      final tableRow = <Widget>[];
      final isOdd = (rowNum - headerCount) % 2 != 0;

      if (rowNum < headerCount) {
        for (final dynamic cell in row) {
          final align = headerAlignments[tableRow.length] ?? headerAlignment;
          final textAlign = _textAlign(align);

          tableRow.add(
            Container(
              alignment: align,
              padding: headerPadding,
              constraints: BoxConstraints(minHeight: headerHeight),
              child: Text(
                headerFormat == null
                    ? cell.toString()
                    : headerFormat(tableRow.length, cell),
                style: headerStyle,
                textAlign: textAlign,
              ),
            ),
          );
        }
      } else {
        for (final dynamic cell in row) {
          final align = cellAlignments[tableRow.length] ?? cellAlignment;
          final textAlign = _textAlign(align);
          tableRow.add(
            Container(
              alignment: align,
              padding: cellPadding,
              constraints: BoxConstraints(minHeight: cellHeight),
              child: Text(
                cellFormat == null
                    ? cell.toString()
                    : cellFormat(tableRow.length, cell),
                style: isOdd ? oddCellStyle : cellStyle,
                textAlign: textAlign,
              ),
            ),
          );
        }
      }

      var decoration = isOdd ? oddRowDecoration : rowDecoration;
      if (rowNum < headerCount) {
        decoration = headerDecoration;
      }

      rows.add(TableRow(
        children: tableRow,
        repeat: rowNum < headerCount,
        decoration: decoration,
      ));
      rowNum++;
    }
    return Table(
      border: border,
      tableWidth: tableWidth,
      children: rows,
      columnWidths: columnWidths,
      defaultColumnWidth: defaultColumnWidth,
      defaultVerticalAlignment: TableCellVerticalAlignment.full,
    );
  }
