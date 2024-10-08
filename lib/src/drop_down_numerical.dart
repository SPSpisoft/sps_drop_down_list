import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sps_drop_down_list/model/double_extention.dart';

import '../model/selected_list_item.dart';
import 'horizontal_list.dart';
import 'numerical_view.dart';

typedef BottomNumSheetListener = bool Function(
    DraggableScrollableNotification draggableScrollableNotification);

typedef ListItemsCallBack = Function(List<double>? listItems);
typedef NewSetCallBack = Function(double? prndingValue);
typedef RangeCallBack = Function(bool isOutOfRange);

class DropDownNumerical {
  /// This will give the call back to the selected items from list.
  final ListItemsCallBack? refreshItems;
  final NewSetCallBack? newSetCallBack;
  final RangeCallBack? rangeCallBack;

  final bool showDoneOnHeader;

  /// You can set your custom submit button when the multiple selection is enabled.
  final Widget? submitButtonChild;
  final int? submitButtonFlex;
  final Widget? cancelButtonChild;
  final EdgeInsets? buttonPadding;
  final String? labelText;
  final String? hintText;

  final String? txtAverage;
  final String? txtDeviation;
  final String? txtAdd;
  final bool noAcceptMax;
  final bool vibrateOnOutRange;

  /// [isDismissible] Specifies whether the bottom sheet will be dismissed when user taps on the scrim.
  /// If true, the bottom sheet will be dismissed when user taps on the scrim.
  /// by default it is [True].
  final bool isDismissible;
  final bool fromSide;
  final bool noCloseDialog;
  final double? widthSide;
  final double? minValue;
  final double? maxValue;
  final double? ratioRange;
  final int? decimalPlace;
  final List<double>? valuesListInit;

  final TextStyle? textStyle;

  EdgeInsetsGeometry? margin;

  final Widget? customTopWidget;

  /// This gives the bottom sheet title.
  final Widget? bottomSheetTitle;

  /// This will set the background color to the dropdown.
  final Color dropDownBackgroundColor;

  /// [bottomSheetListener] that listens for BottomSheet bubbling up the tree.
  final BottomNumSheetListener? bottomSheetListener;
  final String? description;

  Widget? inputDescriptionWidget;

  List<double> valuesList = [];

  DropDownNumerical({
    Key? key,
    this.refreshItems,
    this.newSetCallBack,
    this.customTopWidget,
    this.rangeCallBack,
    this.hintText,
    this.labelText,
    this.description,
    this.txtAverage,
    this.txtDeviation,
    this.txtAdd,
    this.vibrateOnOutRange = true,
    this.noAcceptMax = true,
    this.inputDescriptionWidget,
    this.showDoneOnHeader = false,
    this.isDismissible = true,
    this.submitButtonChild,
    this.submitButtonFlex,
    this.cancelButtonChild,
    this.fromSide = false,
    this.widthSide,
    this.margin,
    this.bottomSheetListener,
    this.noCloseDialog = false,
    this.textStyle,
    this.dropDownBackgroundColor = Colors.transparent,
    this.bottomSheetTitle,
    this.buttonPadding,
    this.valuesListInit,
    this.minValue,
    this.maxValue,
    this.ratioRange,
    this.decimalPlace = 0,
  }) {
    if (minValue != null && maxValue != null && minValue! > maxValue!) {
      throw ArgumentError('min and max must not be null');
    }

    if (minValue != null &&
        maxValue != null &&
        valuesListInit != null &&
        valuesListInit!.any((v) => v > maxValue! || v < minValue!)) {
      throw ArgumentError('any or more value (in valuesList) is out of range');
    }

    if (valuesListInit != null) {
      valuesList.addAll(valuesListInit!);
    }
  }
// : assert(minValue == null || maxValue == null || minValue < maxValue, 'min must be smaller than max');
}

class DropDownNumState {
  DropDownNumerical dropDownNumerical;

  DropDownNumState(this.dropDownNumerical);

  /// This gives the bottom sheet widget.
  void showModal(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: dropDownNumerical.fromSide
          ? Colors.transparent
          : dropDownNumerical.dropDownBackgroundColor,
      enableDrag: dropDownNumerical.isDismissible,
      isDismissible: dropDownNumerical.isDismissible,
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return dropDownNumerical.fromSide
                  ? Row(
                      // alignment: Alignment.topRight,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            if (dropDownNumerical.isDismissible) {
                              Navigator.maybePop(context);
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        )),
                        Container(
                          margin: dropDownNumerical.margin,
                          width: dropDownNumerical.widthSide ??
                              MediaQuery.of(context).size.width / 2,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: dropDownNumerical.dropDownBackgroundColor,
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(15.0)),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: NumPadBody(
                                  dropDownNumerical: dropDownNumerical,
                                  fromSide: dropDownNumerical.fromSide,
                                  maxValue: dropDownNumerical.maxValue,
                                  minValue: dropDownNumerical.minValue,
                                  decimalPlace: dropDownNumerical.decimalPlace,
                                  txtAverage: dropDownNumerical.txtAverage,
                                  txtDeviation: dropDownNumerical.txtDeviation,
                                  txtAdd: dropDownNumerical.txtAdd,
                                  noAcceptMax: dropDownNumerical.noAcceptMax,
                                  vibrateOnOutRange:
                                      dropDownNumerical.vibrateOnOutRange,
                                  noCloseDialog:
                                      dropDownNumerical.noCloseDialog)),
                        ),
                      ],
                    )
                  : NumPadBody(
                      dropDownNumerical: dropDownNumerical,
                      fromSide: dropDownNumerical.fromSide,
                      maxValue: dropDownNumerical.maxValue,
                      minValue: dropDownNumerical.minValue,
                      decimalPlace: dropDownNumerical.decimalPlace,
                      txtAverage: dropDownNumerical.txtAverage,
                      txtDeviation: dropDownNumerical.txtDeviation,
                      txtAdd: dropDownNumerical.txtAdd,
                      noCloseDialog: dropDownNumerical.noCloseDialog);
            },
          ),
        );
      },
    );
  }
}

/// This is main class to display the bottom sheet body.

class NumPadBody extends StatefulWidget {
  final DropDownNumerical dropDownNumerical;
  final bool fromSide;
  final String? txtAverage;
  final String? txtDeviation;
  final String? txtAdd;
  final bool? noCloseDialog;
  final Widget? header;
  final Widget? descriptionWidget;
  final TextStyle? currentValueTextStyle;
  final InputDecoration? currentValueDecoration;
  final double? minValue;
  final double? maxValue;
  final int? decimalPlace;
  final bool vibrateOnOutRange;
  final bool noAcceptMax;

  const NumPadBody(
      {required this.dropDownNumerical,
      required this.fromSide,
      this.txtAverage,
      this.txtDeviation,
      this.txtAdd,
      this.header,
      this.minValue,
      this.maxValue,
      this.vibrateOnOutRange = true,
      this.noAcceptMax = true,
      this.decimalPlace = 0,
      this.descriptionWidget,
      this.currentValueDecoration,
      this.currentValueTextStyle =
          const TextStyle(fontSize: 13, color: Colors.black),
      this.noCloseDialog = false,
      Key? key})
      : super(key: key);

  @override
  State<NumPadBody> createState() => _NumPadBodyState();
}

class _NumPadBodyState extends State<NumPadBody> with TickerProviderStateMixin {
  List<SelectedListItem> mainList = [];

  Color myControlColor = Colors.black87;
  TextStyle myTextLittleStyle = const TextStyle(fontSize: 10, color: Colors.grey);
  TextStyle myTextStyle = const TextStyle(fontSize: 15, color: Colors.black54);
  TextStyle myTextBoldStyle = const TextStyle(
      fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold);

  double minHeight = 0.3;
  double maxHeight = 0.8;
  double initHeight = 0.7;

  TextEditingController currentValueController = TextEditingController();

  List<Widget> myCtrlWidgets = [];

  // Widget? myAddWidgets;

  GlobalKey gKeyDel = GlobalKey();
  GlobalKey gKeyAdd = GlobalKey();

  AnimationController? horizontalListAnimationController;

  String text = "";

  final FocusNode _focusNode = FocusNode();

  final GlobalKey<ListHorizontalState> _listHorizontalKey =
      GlobalKey<ListHorizontalState>();

  var myBoxShadowKeys = const [
    BoxShadow(color: Colors.black54, offset: Offset(0, 1))
  ];

  bool outOfRange = false;


  set isOutOfRange(bool isOutOfRange) {
    outOfRange = isOutOfRange;
    widget.dropDownNumerical.rangeCallBack?.call(outOfRange);
  }

  @override
  void initState() {
    super.initState();
    maxHeight = widget.fromSide ? 1 : 0.7;
    minHeight = widget.fromSide ? 1 : 0.3;

    myCtrlWidgets
        .add(Icon(Icons.backspace_outlined, color: Colors.grey, key: gKeyDel));

    // myAddWidgets = ;

    // Text(widget.txtDeviation?? "ADD",
    // style: TextStyle(color: isOutOfRange ? Colors.grey : Colors.green),
    // key: gKeyAdd);
    // _setSearchWidgetListener();

    horizontalListAnimationController = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);

    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      _focusNode.requestFocus();
    });
  }

  TextEditingController textEditingController = TextEditingController();

  bool checkRange() {
    return double.parse(text) <= (widget.maxValue ?? double.maxFinite) &&
        (double.parse(text) >= (widget.minValue ?? -double.maxFinite));
  }

  onKeyboardTap(Object? value) {
    setState(() {
      if (value is String) {
        text = text + value;
        if (checkRange()) {
          // widget.callBack(null, true);
          isOutOfRange = false;
          // text = text + value;

          if (text.contains(".") &&
              text.split(".")[1].length >= widget.decimalPlace!) return;
        } else {
          if (widget.noAcceptMax &&
              double.parse(text) > (widget.maxValue ?? double.maxFinite)) {
            text = text.substring(0, text.length - 1);
            // vibrate(mPattern: [0, 50, 200, 100]);
          } else {
            // widget.callBack(null, false);
            isOutOfRange = true;
          }
        }
      } else if (value == gKeyDel) {
        if (text.isNotEmpty) {
          setState(() {
            text = text.substring(0, text.length - 1);

            if (text.isEmpty) {
              isOutOfRange = false;
            } else {
              isOutOfRange = !checkRange();
            }
          });
        }
      } else if (value == gKeyAdd) {
        if (text.isNotEmpty) {
          if ((widget.minValue != null &&
                  double.parse(text) < widget.minValue!) ||
              (widget.maxValue != null &&
                  double.parse(text) > widget.maxValue!)) {
            isOutOfRange = true;
          } else {
            widget.dropDownNumerical.valuesList.add(double.parse(text));
            _listHorizontalKey.currentState?.addItem(double.parse(text));
            isOutOfRange = false;
            text = "";

            widget.dropDownNumerical.refreshItems
                ?.call(widget.dropDownNumerical.valuesList);
          }
        }
      }

      // widget.dropDownNumerical.newSetCallBack?.call(text.isNotEmpty && !isOutOfRange);

      textEditingController.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    textEditingController.addListener(
      () {
        bool outOfRange = textEditingController.text.isNotEmpty &&
            ((widget.minValue != null &&
                    double.parse(textEditingController.text) <
                        widget.minValue!) ||
                (widget.maxValue != null &&
                    double.parse(textEditingController.text) >
                        widget.maxValue!));

        widget.dropDownNumerical.newSetCallBack?.call(
            (textEditingController.text.isNotEmpty && !outOfRange)
                ? double.parse(textEditingController.text)
                : null);
      },
    );
    double height = MediaQuery.sizeOf(context).height;
    return NotificationListener<DraggableScrollableNotification>(
        onNotification: widget.dropDownNumerical.bottomSheetListener,
        child: Container(
            height: initHeight * height,
            constraints: BoxConstraints(
              maxHeight: maxHeight * height,
              minHeight: minHeight * height,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Bottom sheet title text
                      Expanded(
                          child: widget.dropDownNumerical.bottomSheetTitle ??
                              Container()),

                      /// Done button
                      Visibility(
                        visible:
                            // widget.dropDown.enableMultipleSelection &&
                            widget.dropDownNumerical.showDoneOnHeader,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: widget.dropDownNumerical.submitButtonChild ??
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                        color: Colors.transparent, width: 0)),
                                color: Colors.green.shade300,
                                onPressed: () {
                                  _onUnFocusKeyboardAndPop();
                                },
                                child: const Text('Done'),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                // padding: const EdgeInsets.only(top: 24, left: 16, right: 16),

                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 24, left: 16, right: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.apply(
                                          color: Colors.black,
                                          fontSizeFactor: 1.5,
                                          fontWeightDelta: 1),
                                  textInputAction: TextInputAction.done,
                                  enabled: true,
                                  readOnly: true,
                                  autofocus: true,
                                  focusNode: _focusNode,
                                  showCursor: true,
                                  // cursorColor: Colors.blue,
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                    suffix: widget.dropDownNumerical
                                            .inputDescriptionWidget ??
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ((widget.minValue != null &&
                                                    widget.maxValue != null)
                                                ? Text(
                                                    "( " +
                                                        widget.minValue
                                                            .toString() +
                                                        " .. " +
                                                        widget.maxValue
                                                            .toString() +
                                                        " )",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: outOfRange
                                                            ? Colors.red
                                                            : Colors.grey),
                                                  )
                                                : const SizedBox()),
                                            ((widget.dropDownNumerical
                                                        .description !=
                                                    null)
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: Text(
                                                      widget.dropDownNumerical
                                                          .description!,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: outOfRange
                                                              ? Colors.red
                                                              : Colors.grey),
                                                    ),
                                                  )
                                                : const SizedBox()),
                                          ],
                                        ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: const OutlineInputBorder(),
                                    labelText:
                                        widget.dropDownNumerical.labelText ??
                                            "Input",
                                    hintText: widget.dropDownNumerical.hintText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        widget.dropDownNumerical.customTopWidget ??
                            const SizedBox(),
                        widget.dropDownNumerical.valuesList.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListHorizontal(
                                  lastList:
                                      widget.dropDownNumerical.valuesListInit,
                                  valuesList: widget
                                      .dropDownNumerical.valuesList.reversed
                                      .toList(),
                                  lowRange: getLowRange(),
                                  hiRange: getHiRange(),
                                  callBackRemove: (i) {
                                    setState(() {
                                      widget.dropDownNumerical.valuesList
                                          .removeAt(widget.dropDownNumerical
                                                  .valuesList.length -
                                              1 -
                                              i);

                                      widget.dropDownNumerical.refreshItems
                                          ?.call(widget
                                              .dropDownNumerical.valuesList);
                                    });
                                  },
                                  key: _listHorizontalKey,
                                  // animationController:
                                  //     horizontalListAnimationController,
                                ),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.black12,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 12, left: 12, bottom: 12),
                          child: Visibility(
                            visible: widget.dropDownNumerical.valuesList.length >= 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.txtAverage ?? "Average : ",
                                      style: myTextStyle,
                                    ),
                                    Text(
                                      numericalAvgToText(
                                          widget.dropDownNumerical.valuesList,
                                          widget.decimalPlace!)?? "",
                                      style: myTextBoldStyle,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.txtDeviation ?? "St.Deviation : ",
                                      style: myTextStyle,
                                    ),
                                    Text(
                                      numericalStandardToText(
                                          widget.dropDownNumerical.valuesList, 2)?? "",
                                      style: myTextBoldStyle,
                                    )
                                  ],
                                ),
                                // const SizedBox(
                                //   width: 25,
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //     getLowRange() != null ? getLowRange().toString() : "",
                                //       style: myTextLittleStyle,
                                //     ),
                                //     Text(
                                //       " .. ", style: myTextLittleStyle,
                                //     ),
                                //     Text(
                                //       getHiRange() != null ? getHiRange().toString() : "",
                                //       style: myTextLittleStyle,
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: NumericKeyboard(
                            onKeyboardTap: onKeyboardTap,
                            ctrlWidgets: myCtrlWidgets,
                            addWidget: Expanded(
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      // widget.onKeyboardTap(widget.addWidget!.key);
                                      if (!outOfRange && text.isNotEmpty) {
                                        setState(() {
                                          widget.dropDownNumerical.valuesList
                                              .add(double.parse(text));
                                          _listHorizontalKey.currentState
                                              ?.addItem(double.parse(text));
                                          isOutOfRange = true;
                                          text = "";
                                          textEditingController.text = text;
                                        });

                                        widget.dropDownNumerical.refreshItems
                                            ?.call(widget.dropDownNumerical.valuesList);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: outOfRange || text.isEmpty
                                              ? Colors.grey.shade400
                                              : Colors.green.shade300,
                                          boxShadow: myBoxShadowKeys,
                                        ),
                                        alignment: Alignment.center,
                                        // height: double.infinity,
                                        // width: widget.sizeNumButton ?? 22.parentW(cons),
                                        // height: widget.sizeNumButton ?? 70,
                                        child: Text(
                                            widget.txtDeviation ?? "ADD",
                                            style: const TextStyle(
                                                color: Colors.white),
                                            key: gKeyAdd),
                                      ),
                                    ))),
                            boxShadow: myBoxShadowKeys,
                            leftIcon: const Center(
                              child: Text("-/+",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20)),
                            ),
                            leftButtonFn: () {
                              if (text.isEmpty) return;
                              setState(() {
                                if (text.substring(0, 1) == '-' &&
                                    double.parse(text) * -1 <=
                                        widget.maxValue!) {
                                  text = text.substring(1);
                                } else if (widget.minValue == null ||
                                    (widget.minValue! < 0 &&
                                        double.parse(text) * -1 >=
                                            widget.minValue!)) {
                                  text = "-" + text;
                                }
                                textEditingController.text = text;
                              });
                            },
                            rightIcon: const Center(
                              child: Text(".",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20)),
                            ),
                            rightButtonFn: () {
                              if (text.isEmpty ||
                                  text.contains(".") ||
                                  widget.decimalPlace == 0) return;
                              setState(() {
                                text = text + ".";
                                textEditingController.text = text;
                              });
                            },
                          ),
                        ),

                        /// Controller Button
                        Visibility(
                          visible:
                              // widget.dropDownNumerical.enableMultipleSelection &&
                              !widget.dropDownNumerical.showDoneOnHeader,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: widget.dropDownNumerical.buttonPadding ??
                                  const EdgeInsets.only(
                                      right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  widget.dropDownNumerical.cancelButtonChild !=
                                          null
                                      ? Expanded(
                                          flex: 1,
                                          child: widget.dropDownNumerical
                                              .cancelButtonChild!,
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    flex: widget.dropDownNumerical
                                            .submitButtonFlex ??
                                        2,
                                    child: widget.dropDownNumerical
                                            .submitButtonChild ??
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0)),
                                          color: Colors.green.shade500,
                                          onPressed: () {},
                                          child: const Text('Done',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  String? numericalAvgToText(List<double>? valueListInit, int decimal, {bool withOutLast = true}) {
    String? ret;

    List<double> valueList = [];

    if (valueListInit != null && valueListInit.length > 1) {

      valueList.addAll(valueListInit);

      if(withOutLast){
        valueList.removeLast();
      }

      double value =
          valueList.map((m) => m).reduce((a, b) => a + b).toPrecision(decimal) /
              valueList.length;
      ret = value.toString();
      try {
        if (decimal == 0) {
          ret = ret.split(".")[0];
        } else {
          while (ret!.split(".")[1].length < decimal) {
            ret = "${ret}0";
          }
          if (ret.split(".")[1].length > decimal) {
            ret =
                "${ret.split(".")[0]}.${ret.split(".")[1].substring(0, decimal)}";
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    return ret;
  }

  String? numericalStandardToText(List<double>? valueListInit, int decimal, {bool withOutLast = true}) {
    String? ret;
    List<double> numbers = [];

    if (valueListInit == null || valueListInit.length < 2) return ret;

    numbers.addAll(valueListInit);

    if(withOutLast){
      numbers.removeLast();
    }

    double mean = numbers.reduce((a, b) => a + b) / numbers.length;

    double variance =
        numbers.map((number) => pow(number - mean, 2)).reduce((a, b) => a + b) /
            numbers.length;

    ret = sqrt(variance).toString();

    try {
      if (decimal == 0) {
        ret = ret.split(".")[0];
      } else {
        while (ret!.split(".")[1].length < decimal) {
          ret = "${ret}0";
        }
        if (ret.split(".")[1].length > decimal) {
          ret =
              "${ret.split(".")[0]}.${ret.split(".")[1].substring(0, decimal)}";
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return ret;
  }

  _onUnFocusKeyboardAndPop() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  double? getLowRange() {
    String? avg = numericalAvgToText(
        widget.dropDownNumerical.valuesList,
        widget.decimalPlace!);
    String? st = numericalStandardToText(
        widget
            .dropDownNumerical.valuesList,
        2);
    if(avg == null || st == null) {
      return null;
    } else {
      return double.parse(avg) -
        (double.parse(st) *
            (widget.dropDownNumerical
                .ratioRange ??
                0));
    }
  }

  double? getHiRange() {
    String? avg = numericalAvgToText(
        widget.dropDownNumerical.valuesList,
        widget.decimalPlace!);
    String? st = numericalStandardToText(
        widget
            .dropDownNumerical.valuesList,
        2);
    if (avg == null || st == null) {
      return null;
    } else {
      return double.parse(avg) +
          (double.parse(st) *
              (widget.dropDownNumerical
                  .ratioRange ??
                  0));
    }
  }

// Future<void> vibrate(
//     {int mDuration = 1000,
//     int mRepeat = 0,
//     int mAmplitude = 0,
//     List<int> mIntensities = const [],
//     List<int> mPattern = const []}) async {
//   await Vibration.hasCustomVibrationsSupport()
//       .then((hasVibrationsSupport) async {
//     if (hasVibrationsSupport ?? false) {
//       Vibration.vibrate(
//           duration: mDuration,
//           amplitude: mAmplitude,
//           intensities: mIntensities,
//           pattern: mPattern);
//     } else {
//       Vibration.vibrate();
//       await Future.delayed(Duration(milliseconds: mDuration));
//       Vibration.vibrate();
//     }
//   });
// }
}
