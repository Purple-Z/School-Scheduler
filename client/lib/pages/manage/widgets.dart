import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';

class DataTableWidget extends StatefulWidget {
  final List<String> header;
  final List items;
  final List<bool> itemsColumn;
  final VoidCallback? onRefresh;
  final void Function(List) onItemTap;
  final RefreshController refreshController;
  const DataTableWidget({
    Key? key,
    required this.header,
    required this.onRefresh,
    required this.onItemTap,
    required this.items,
    required this.itemsColumn,
    required this.refreshController,
  }) : super(key: key);

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          children: [
            for (String header_label in widget.header)
            Expanded(child: Center(child: SizedBox(height: 35, child: Text(header_label, style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))))),
          ],
        ),
        Expanded( 
          child: SmartRefresher(
            controller: widget.refreshController,
            onRefresh: widget.onRefresh,
            header: MaterialClassicHeader(),
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                List item = widget.items[index] as List;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Divider(),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
                      ),
                      onPressed: () => widget.onItemTap(item),
                      child: Row(
                        children: [
                          for (int i = 0; i < item.length; i++)
                            if (widget.itemsColumn[i])
                              Expanded(
                                child: Center(
                                  child: Text("${item[i]}"),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
