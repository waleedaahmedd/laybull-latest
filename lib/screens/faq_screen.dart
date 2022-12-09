import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  bool? _customTileExpanded0 = false;
  bool? _customTileExpanded1 = false;
  bool? _customTileExpanded10 = false;
  bool? _customTileExpanded11 = false;
  bool? _customTileExpanded12 = false;
  bool? _customTileExpanded13 = false;
  bool? _customTileExpanded14 = false;
  bool? _customTileExpanded15 = false;
  bool? _customTileExpanded16 = false;
  bool? _customTileExpanded17 = false;
  bool? _customTileExpanded18 = false;
  bool? _customTileExpanded19 = false;
  bool? _customTileExpanded2 = false;
  bool? _customTileExpanded20 = false;
  bool? _customTileExpanded21 = false;
  bool? _customTileExpanded22 = false;
  bool? _customTileExpanded23 = false;
  bool? _customTileExpanded24 = false;
  bool? _customTileExpanded25 = false;
  bool? _customTileExpanded26 = false;
  bool? _customTileExpanded27 = false;
  bool? _customTileExpanded28 = false;
  bool? _customTileExpanded29 = false;
  bool? _customTileExpanded3 = false;
  bool? _customTileExpanded30 = false;
  bool? _customTileExpanded4 = false;
  bool? _customTileExpanded5 = false;
  bool? _customTileExpanded6 = false;
  bool? _customTileExpanded7 = false;
  bool? _customTileExpanded8 = false;
  bool? _customTileExpanded9 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            size: 24.h,
            color: Colors.black,
          ),
        ),
        title: Text(
          "FAQ'S",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BUYERS",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How do I know once my offer has been accepted by the seller?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded0!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded0!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Once a seller has accepted your offer, you will be notified both via in-app push notifications & receive an email. The order will automatically process and be shipped out to you.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded0 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Are returns or exchanges accepted?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded1!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded1!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'We accept neither returns nor exchanges unless reasoned (see below) due to the circumstance that Laybull is a consignment marketplace, which means that we are always in the middle. Doing so, would make it unfair on a seller if the item is delivered as described. However, we give every purchase the benefit of filing for a full refund within 24 hours after delivery if the following applies.\n 1. The item did not arrive as described \n 2. The item did not arrive in full (Missing box, laces, accessory, extras)\nLaybull receives all items on-hand for authentication & quality checks before being shipped out to you. Incase we feel that the item arrived in a different but minor condition from what the seller has described, we will always reach out to you before shipping the item. If you are not satisfied, we will return the item and issue a full refund. We consider all parts of the product as important as the other such as laces, box & extras to ensure that the overall presentation is exactly as one would anticipate.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded1 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How long does it take until I receive my order?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded2!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded2!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Delivery time starts directly after a product is purchased. All mentioned shipping periods below include authentication & quality check processes.\nUAE: 2-4 working days.\nSaudi Arabia: 4-8 working days.\nQatar: 4-8 working days.\nKuwait: 4-8 working days.\nBahrain: 4-8 working days.\nOman: 4-8 working days.\nLebanon: 4-8 working days.\nPalestine: 4-8 working days.\nJordan: 4-8 working days.\nIndia: 5-10 working days',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded2 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Which countries can I make purchases from? Where does Laybull ship to?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded3!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded3!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'As of now, we only ship within the United Arab Emirates (UAE) as part of the BETA testing program. Once completed, Laybull delivers to all countries within the Middle East & India.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded3 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How are products at Laybull authenticated and what are my guarantees?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded4!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded4!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'To ensure the safety of our products & community, all items sold go through us first for in-hand authentication & quality checked before being shipped out to you. Our authentication experts are always monitoring the marketplace to prevent the team from receiving a fake in the first place, as well as reviewing each and every single listing before making it live. However, the team are always being trained with the highest and latest methods of authenticating to make sure that a fake item does not get shipped to you if encountered.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded4 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'What if a seller doesn’t ship my item?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded5!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded5!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'We give sellers 2 days to ship their item out to our authentication centre in order to reduce your delivery time as much as possible. If the seller fails to do so, we will not accept a later date and issue you a full refund as well as try and locate the same pair, size & condition for you.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded5 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How do I make a purchase?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded6!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded6!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Simply create an account and enter all of your basic, shipping & payment details to make your next transaction smoother. After you’ve found the item you like, add it to your cart and checkout within seconds.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded6 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'What payment methods do you accept?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded7!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded7!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'We currently only accept credit/debit card payments but we are working hard to adding more payment methods such as PayPal, Bank transfer & partner up with installment providers.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded7 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Can I change my shipping address once my order has been placed?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded8!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded8!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Shipping addresses can be changed within 24 hours after placing as we expect to receive the product in-hand within 48 hours of your order. To do so, simply email us at orders@laybull.com',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded8 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Why have I not received my order?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded9!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded9!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Please allow up to 7 working days to receive your order. If your order still hasn’t arrived, please contact our support team and we will be happy to assist you.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded9 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'I received my order but it’s in a different condition than expected. What do I do now?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded10!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded10!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'If your item arrived in a different condition than described, please make sure to take pictures of the presentation from all angles and contact our support team which will be happy to assist you. NOTE that Laybull is not held responsible for any damages caused by shipping.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded10 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How can I cancel my order?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded11!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded11!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'If you have placed an order and would like to cancel it, please contact our support team to see if you’re eligible. Please note that cancellations are never possible if the seller has already shipped your item.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded11 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'I’m having issues purchasing a product. How can I sort this out?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded12!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded12!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'If purchasing a products isn’t as easy as you thought or you are encountering an error/big within the application itself, please contact our support team to resolve the issue immediately.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded12 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'I placed an order but haven’t received a confirmation email yet. Should I be worried?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded13!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded13!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Please allow up to 24 hours to receive a confirmation email. If you have not received an email within the given time frame, please contact our support team to receive the order confirmation.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded13 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'If the seller has offered a discount for issues I’ve found after receiving my product, how would that be applied?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded14!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded14!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Once we receive the item at the authentication centre, we take the quality and presentation of your item to the highest regard, as well as its authenticity. If a product doesn’t match a description that the seller has provided, they will have the option I give a discounted price & if the discounted price is accepted by you, then we would implement it from our systems so that it can be updated on both the seller’s and buyer’s accounts.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded14 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Laybull’s authentication team informed me that they found a minor issue in my product. What do I do if I don’t want the purchase anymore?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded15!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded15!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'If our team has informed you of a small flaw or damage within the product on its arrival, we will ask you if you still want to purchase the item. If not, we return the item back to the seller and give you a full refund on the order. Please note that our team will only ask you this if the item has a minor flaw, major flaws are returned immediately without the buyers consent.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded15 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How much does shipping cost?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded16!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded16!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Laybull’s competitive shipping prices ensures that shipping is considered as cost-friendly as any other factor that contributes to the cost of a purchase. Shipping prices also vary depending on the size, weight and destination of the product. During BETA version, please note that shipping is only available to and within the United Arab Emirates.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(
                      () => _customTileExpanded16 = expanded,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Why do I have to pay for return shipping?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded17!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded17!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Laybull is a middleman marketplace which holds no responsibility in covering any costs due to either seller or buyer choices. Any returns or further shipments must be covered by the individual involved.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded17 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "SELLERS",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How do I know once a buyer has offered me a price?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded18!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded18!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Once you receive an offer for your listing, an email and in-app notification will be sent.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded18 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How do I know once my item has been sold?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded19!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded19!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Once your item has been sold, you will be notified via email and in-app notifications as well as an update on the status of your item on the profile section. (Listed -> Sold)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded19 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How do I counter-offer a buyers current bid?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded20!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded20!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Once you have received an offer, you have the option to accept, decline or counter-offer. If you feel like the price is unfair, use the counter-offer button to let the buyer know your new price.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded20 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How long does it take to get my payout once my item has been sold and how do I receive it?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded21!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded21!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Once your item sells, we make sure that the item is shipped to the buyer within 7 working days. Laybull then grants all buyers 24 hours after delivery to open a claim for any faults or damages to the purchased item. Once the time frame is over, the money is immediately transferred to you via BANK TRANSFER to the bank account registered on your profile.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded21 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'What if my item sells and I changed my mind?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded22!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded22!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Unfortunately, after the order has been processed as sold, you must ship your item to avoid any penalty fees & account limitations. This is kept to ensure the buyers safety in receiving their product after a sale has occured. If you are having trouble sending your item for any other reasons then please contact our support team to come to a resolution.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded22 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Why does my listing not go live on the marketplace directly?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded23!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded23!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'As authenticity remains our top priority, we have taken an extra step by reviewing each listing uploaded before making it live in the marketplace. This is to ensure that the post is legit and the description matches the pictures attached.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded23 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Why are my bank details required when I sign up as a seller?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded24!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded24!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'When registering yourself as a seller, you will be asked to provide your bank account details so that we can have an account to transfer your funds once a listing sells.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded24 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'How do I create a listing?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded25!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded25!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Make sure that you have registered as a seller in order to create a listing. Once that is set up, simply click the + icon in the middle-bottom of the application to create a listing.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded25 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'What commissions does Laybull take?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded26!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded26!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Laybull takes a 10% fee on all listings.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded26 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'As a seller, who is responsible for the shipping fees to the authentication centre?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded27!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded27!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'All sellers are responsible for covering shipping fees to our authentication centre.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    setState(() => _customTileExpanded27 = expanded);
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: Text(
                    'My item just sold, what’s next?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded28!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded28!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Once your item sells, a courier will contact you within 1-3 working days to collect your item.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (
                    bool expanded,
                  ) {
                    setState(
                      () => _customTileExpanded28 = expanded,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: Text(
                    'Why is my sellers account suspended?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded29!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded29!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'If you have violated any terms & conditions, we may temporarily or permanently ban your account from selling.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (
                    bool expanded,
                  ) {
                    setState(
                      () => _customTileExpanded29 = expanded,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Theme(
                data: Theme.of(
                  context,
                ).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: Text(
                    'Why has my listing been rejected?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    _customTileExpanded30!
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _customTileExpanded30!
                        ? Colors.black
                        : Colors.grey.shade500,
                    size: 20.h,
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'If your listing doesn’t have enough information or doesn’t meet our requirements, we will notify you on why it has been rejected so that you can make the following changes.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onExpansionChanged: (
                    bool expanded,
                  ) {
                    setState(
                      () => _customTileExpanded30 = expanded,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
