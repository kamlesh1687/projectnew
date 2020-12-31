import 'package:flutter/material.dart';

class SelectableList extends StatefulWidget {
  final bool isTextList;
  final int count;
  final List list;
  final int preselected;
  final Function(int) getSelectedItem;
  final EdgeInsetsGeometry padding;

  final double radius;
  final Color color;
  final Color itemColor;
  final Widget Function(int) builder;
  final Axis scrollDirection;

  const SelectableList({
    Key key,
    this.count,
    this.list,
    @required this.getSelectedItem,
    this.padding,
    this.radius,
    this.color,
    this.itemColor,
    this.preselected,
    this.isTextList,
    this.builder,
    this.scrollDirection,
  }) : super(key: key);
  @override
  _SelectableListState createState() => _SelectableListState();
}

class _SelectableListState extends State<SelectableList> {
  int selectedindex;
  String selectedValue;

  @override
  void initState() {
    selectedindex = widget.preselected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: widget.scrollDirection ?? Axis.horizontal,
            itemCount: widget.count ?? widget.list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Container(
                      padding: widget.padding,
                      decoration: BoxDecoration(
                        color: widget.itemColor,
                        borderRadius: BorderRadius.circular(widget.radius ?? 0),
                        border: Border.all(
                          width: 2,
                          color: selectedindex == index
                              ? (widget.color ?? Theme.of(context).primaryColor)
                              : Colors.transparent,
                        ),
                      ),
                      child: InkWell(
                          borderRadius:
                              BorderRadius.circular(widget.radius ?? 0),
                          onTap: () {
                            setState(() {
                              selectedindex = index;
                            });
                            widget.getSelectedItem(index);
                          },
                          child: widget.builder(index)),
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
