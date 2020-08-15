// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// // import 'package:flutter_redux/flutter_redux.dart';
// import 'package:google_fonts/google_fonts.dart';
// // import 'package:puzzle_Store/models/app_state.dart';
// // import 'package:puzzle_Store/redux/actions.dart';
// import 'package:stripe_payment/stripe_payment.dart';

// class ProfilePage extends StatefulWidget {
//   final void Function() onInit;
//   ProfilePage({this.onInit});
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     super.initState();
//     widget.onInit();
//     StripePayment.setOptions(StripeOptions(
//       publishableKey: "pk_test_zglTAFBriYBOP8VrYIVSBFbR00Mf5sFwtL",
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, AppState>(
//         converter: (store) => store.state,
//         builder: (context, state) {
//           return Scaffold(
//             key: _scaffoldKey,
//             appBar: AppBar(
//               backgroundColor: Colors.black,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//             body: state.user == null
//                 ? noUserContainer(context)
//                 : userExistsContainer(context, state),
//           );
//         });
//   }

//   Container userExistsContainer(BuildContext context, AppState state) {
//     _addCard(cardToken) async {
//       await http.put('http://10.0.2.2:1337/users/${state.user.id}',
//           body: {"card_token": cardToken},
//           headers: {"Authorization": "Bearer ${state.user.jwt}"});

//       http.Response response =
//           await http.post('http://10.0.2.2:1337/card/add', body: {
//         "source": cardToken,
//         "customer": state.user.stripeId,
//       });
//       final responseData = json.decode(response.body);
//       print(responseData);
//       return responseData;
//     }

//     return Container(
//       child: Column(
//         children: <Widget>[
//           userDataWidget(state),
//           Divider(
//             thickness: 1,
//             color: Colors.grey,
//           ),
//           ListTile(
//             trailing: IconButton(
//                 icon: Icon(
//                   Icons.add,
//                   color: Colors.white,
//                 ),
//                 onPressed: () async {
//                   final PaymentMethod cardToken =
//                       await StripePayment.paymentRequestWithCardForm(
//                     CardFormPaymentRequest(),
//                   ).catchError((e) => print(e));
//                   final card = await _addCard(cardToken.id);
//                   //print(card);

//                   //1- dispatch an action to store the card in the state with the other cards.
//                   StoreProvider.of<AppState>(context)
//                       .dispatch(AddCardAction(card));
//                   //2- update card token (the one on the server means it is the primary one)
//                   StoreProvider.of<AppState>(context)
//                       .dispatch(UpdateCardTokenAction(card['id']));
//                   //3- show snack bar of success !
//                   final Widget snackBar = SnackBar(
//                     content: Text(
//                       'card added successfuly',
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   );
//                   _scaffoldKey.currentState.showSnackBar(snackBar);
//                 }),
//             leading: Icon(Icons.credit_card, color: Colors.white),
//             title: Text(
//               'credit cards',
//               style: GoogleFonts.getFont(
//                 'Manrope',
//                 textStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ),
//           state.cards.length == 0
//               ? noCreditCardsWidget()
//               : SizedBox(
//                   height: 200,
//                   child: ListView.builder(
//                     padding: EdgeInsets.all(10),
//                     scrollDirection: Axis.horizontal,
//                     itemCount: state.cards.length,
//                     itemBuilder: (context, index) {
//                       return creditCardContainer(state, index);
//                     },
//                   ),
//                 ),
//           ListTile(
//             leading: Icon(Icons.receipt, color: Colors.white),
//             title: Text(
//               'Reciepts',
//               style: GoogleFonts.getFont(
//                 'Manrope',
//                 textStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ),
//           state.orders.length == 0
//               ? noRecieptsWidget()
//               : Expanded(
//                   //height: 100,
//                   child: ListView.builder(
//                     //padding: EdgeInsets.all(10),
//                     itemCount: state.orders.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         leading: Icon(Icons.monetization_on),
//                         title: Text(
//                           '${state.orders[index].amount}',
//                           style: GoogleFonts.getFont(
//                             'Manrope',
//                             textStyle: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         subtitle: Text(
//                           '${state.orders[index].createdAt}',
//                           style: GoogleFonts.getFont(
//                             'Manrope',
//                             textStyle: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//           Divider(
//             thickness: 1,
//             color: Colors.grey,
//           ),
//           logOutButton(context),
//         ],
//       ),
//     );
//   }

//   ListTile logOutButton(BuildContext context) {
//     return ListTile(
//       leading: Icon(Icons.exit_to_app, color: Colors.red),
//       onTap: () {
//         StoreProvider.of<AppState>(context).dispatch(logUserOutAction);
//       },
//       title: Text(
//         'Logout',
//         style: GoogleFonts.getFont(
//           'Manrope',
//           textStyle: TextStyle(
//             color: Colors.red,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     );
//   }

//   Padding userDataWidget(AppState state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 18.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           CircleAvatar(
//             child: Icon(
//               Icons.person_pin,
//               size: 60,
//               color: Colors.black,
//             ),
//             radius: 40,
//             backgroundColor: Colors.white,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Username : ${state.user.username}',
//                 style: GoogleFonts.getFont(
//                   'Manrope',
//                   textStyle: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               Text(
//                 'Email : ${state.user.email}',
//                 style: GoogleFonts.getFont(
//                   'Manrope',
//                   textStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Text noCreditCardsWidget() {
//     return Text(
//       'you have no credit cards',
//       style: GoogleFonts.getFont(
//         'Manrope',
//         textStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//         ),
//       ),
//     );
//   }

//   Text noRecieptsWidget() {
//     return Text(
//       'When you buy something your reciepts will appear here.',
//       style: GoogleFonts.getFont(
//         'Manrope',
//         textStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//         ),
//       ),
//     );
//   }

//   Container creditCardContainer(AppState state, int index) {
//     return Container(
//       margin: EdgeInsets.all(10),
//       padding: EdgeInsets.fromLTRB(45, 20, 5, 0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.blue[200],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Text(
//             '**** **** **** ${state.cards[index]['card']['last4']} ',
//             style: GoogleFonts.getFont(
//               'Manrope',
//               textStyle: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//           ),
//           Column(
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(right: 30.0),
//                     child: Text(
//                       '${state.cards[index]['card']['brand']}',
//                       style: GoogleFonts.getFont(
//                         'Manrope',
//                         textStyle: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     '${state.cards[index]['card']['exp_month']}  / ${state.cards[index]['card']['exp_year']}',
//                     style: GoogleFonts.getFont(
//                       'Manrope',
//                       textStyle: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               FlatButton.icon(
//                 onPressed: () {
//                   StoreProvider.of<AppState>(context).dispatch(
//                       UpdateCardTokenAction(state.cards[index]['id']));
//                 },
//                 icon: state.cards[index]['id'] == state.cardToken
//                     ? Icon(Icons.star)
//                     : Icon(Icons.star_border),
//                 label: state.cards[index]['id'] == state.cardToken
//                     ? Text('primary card')
//                     : Text('set as primary'),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Container noUserContainer(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Please Login Or Register First',
//             style: GoogleFonts.getFont(
//               'Manrope',
//               textStyle: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 60,
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: FlatButton(
//                   onPressed: () {
//                     Navigator.of(context).pushNamed('/login');
//                   },
//                   child: Text(
//                     'Login',
//                     style: GoogleFonts.getFont(
//                       'Manrope',
//                       textStyle: TextStyle(
//                         //fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                   color: Colors.white,
//                 ),
//               ),
//               FlatButton(
//                 onPressed: () {
//                   Navigator.of(context).pushNamed('/register');
//                 },
//                 child: Text(
//                   'register',
//                   style: GoogleFonts.getFont(
//                     'Manrope',
//                     textStyle: TextStyle(
//                       //fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//                 color: Colors.white,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'styles.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/animation.dart';
// import 'dart:async';
// import '../../widgets/ListViewContainer.dart';
// import '../../Components/AddButton.dart';
// import '../../Components/HomeTopView.dart';
// import '../../Components/FadeContainer.dart';
// import 'homeAnimation.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key key}) : super(key: key);

//   @override
//   HomeScreenState createState() => new HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   Animation<double> containerGrowAnimation;
//   AnimationController _screenController;
//   AnimationController _buttonController;
//   Animation<double> buttonGrowAnimation;
//   Animation<double> listTileWidth;
//   Animation<Alignment> listSlideAnimation;
//   Animation<Alignment> buttonSwingAnimation;
//   Animation<EdgeInsets> listSlidePosition;
//   Animation<Color> fadeScreenAnimation;
//   var animateStatus = 0;
//   List<String> months = [
//     "January",
//     "February",
//     "March",
//     "April",
//     "May",
//     "June",
//     "July",
//     "August",
//     "September",
//     "October",
//     "November",
//     "December"
//   ];
//   String month = new DateFormat.MMMM().format(
//     new DateTime.now(),
//   );
//   int index = new DateTime.now().month;
//   void _selectforward() {
//     if (index < 12)
//       setState(() {
//         ++index;
//         month = months[index - 1];
//       });
//   }

//   void _selectbackward() {
//     if (index > 1)
//       setState(() {
//         --index;
//         month = months[index - 1];
//       });
//   }

//   @override
//   void initState() {
//     super.initState();

//     _screenController = new AnimationController(
//         duration: new Duration(milliseconds: 2000), vsync: this);
//     _buttonController = new AnimationController(
//         duration: new Duration(milliseconds: 1500), vsync: this);

//     fadeScreenAnimation = new ColorTween(
//       begin: const Color.fromRGBO(247, 64, 106, 1.0),
//       end: const Color.fromRGBO(247, 64, 106, 0.0),
//     )
//         .animate(
//       new CurvedAnimation(
//         parent: _screenController,
//         curve: Curves.ease,
//       ),
//     );
//     containerGrowAnimation = new CurvedAnimation(
//       parent: _screenController,
//       curve: Curves.easeIn,
//     );

//     buttonGrowAnimation = new CurvedAnimation(
//       parent: _screenController,
//       curve: Curves.easeOut,
//     );
//     containerGrowAnimation.addListener(() {
//       this.setState(() {});
//     });
//     containerGrowAnimation.addStatusListener((AnimationStatus status) {});

//     listTileWidth = new Tween<double>(
//       begin: 1000.0,
//       end: 600.0,
//     )
//         .animate(
//       new CurvedAnimation(
//         parent: _screenController,
//         curve: new Interval(
//           0.225,
//           0.600,
//           curve: Curves.bounceIn,
//         ),
//       ),
//     );

//     listSlideAnimation = new AlignmentTween(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//     )
//         .animate(
//       new CurvedAnimation(
//         parent: _screenController,
//         curve: new Interval(
//           0.325,
//           0.700,
//           curve: Curves.ease,
//         ),
//       ),
//     );
//     buttonSwingAnimation = new AlignmentTween(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomRight,
//     )
//         .animate(
//       new CurvedAnimation(
//         parent: _screenController,
//         curve: new Interval(
//           0.225,
//           0.600,
//           curve: Curves.ease,
//         ),
//       ),
//     );
//     listSlidePosition = new EdgeInsetsTween(
//       begin: const EdgeInsets.only(bottom: 16.0),
//       end: const EdgeInsets.only(bottom: 80.0),
//     )
//         .animate(
//       new CurvedAnimation(
//         parent: _screenController,
//         curve: new Interval(
//           0.325,
//           0.800,
//           curve: Curves.ease,
//         ),
//       ),
//     );
//     _screenController.forward();
//   }

//   @override
//   void dispose() {
//     _screenController.dispose();
//     _buttonController.dispose();
//     super.dispose();
//   }

//   Future<Null> _playAnimation() async {
//     try {
//       await _buttonController.forward();
//     } on TickerCanceled {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     timeDilation = 0.3;
//     Size screenSize = MediaQuery.of(context).size;

//     return (new WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: new Scaffold(
//         body: new Container(
//           width: screenSize.width,
//           height: screenSize.height,
//           child: new Stack(
//             //alignment: buttonSwingAnimation.value,
//             alignment: Alignment.bottomRight,
//             children: <Widget>[
//               new ListView(
//                 shrinkWrap: _screenController.value < 1 ? false : true,
//                 padding: const EdgeInsets.all(0.0),
//                 children: <Widget>[
//                   new ImageBackground(
//                     backgroundImage: backgroundImage,
//                     containerGrowAnimation: containerGrowAnimation,
//                     profileImage: profileImage,
//                     month: month,
//                     selectbackward: _selectbackward,
//                     selectforward: _selectforward,
//                   ),
//                   //new Calender(),
//                   new ListViewContent(
//                     listSlideAnimation: listSlideAnimation,
//                     listSlidePosition: listSlidePosition,
//                     listTileWidth: listTileWidth,
//                   )
//                 ],
//               ),
//               new FadeBox(
//                 fadeScreenAnimation: fadeScreenAnimation,
//                 containerGrowAnimation: containerGrowAnimation,
//               ),
//               animateStatus == 0
//                   ? new Padding(
//                       padding: new EdgeInsets.all(20.0),
//                       child: new InkWell(
//                           splashColor: Colors.white,
//                           highlightColor: Colors.white,
//                           onTap: () {
//                             setState(() {
//                               animateStatus = 1;
//                             });
//                             _playAnimation();
//                           },
//                           child: new AddButton(
//                             buttonGrowAnimation: buttonGrowAnimation,
//                           )))
//                   : new StaggerAnimation(
//                       buttonController: _buttonController.view),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }
