// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
//
// import '../../domain/entity/message_entity.dart';
// import '../../domain/entity/user_entity.dart';
// import '../cubit/chat_list/chat_list_cubit.dart';
// import '../cubit/last_message/last_message_cubit.dart';
// import '../cubit/user/user_cubit.dart';
// import '../widget/text_field_widget.dart';
// import '../widget/user_widget.dart';
// import 'chat_room_screen.dart';
//
// class SearchScreen extends StatefulWidget {
//   static route(UserEntity entity) => MaterialPageRoute(
//         builder: (context) => SearchScreen(
//           userEntity: entity,
//         ),
//       );
//
//   final UserEntity userEntity;
//   const SearchScreen({Key? key, required this.userEntity}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController controllerSearch = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return KeyboardDismissOnTap(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//           ),
//           title: const Text(
//             'Search',
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: true,
//         ),
//         body: RefreshIndicator(
//           onRefresh: () async {
//             BlocProvider.of<ChatListCubit>(context).load();
//           },
//           child: BlocBuilder<ChatListCubit, ChatListState>(
//             bloc: BlocProvider.of<ChatListCubit>(context)..load(),
//             builder: (context, state) {
//               if (state is ChatListLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               if (state is ChatListLoaded) {
//                 return ListView(
//                   children: [
//                     const SizedBox(height: 10),
//                     TextFormFieldWidget(
//                       controller: controllerSearch,
//                       hint: 'Name',
//                       prefixIcon: Icons.search,
//                     ),
//                     const SizedBox(height: 5),
//                     ...state.chats.map(
//                       (data) => BlocBuilder<LastMessageCubit, LastMessageState>(
//                         bloc: data.lastMessageCubit,
//                         builder: (context, state) {
//                           MessageEntity? lastMessage;
//                           int count = 0;
//
//                           if (state is LastMessageLoaded) {
//                             lastMessage = state.chatRoom.lastMessage;
//                             count = state.notReadMessageCount;
//                           }
//                           return UserWidget(
//                             title: '${data.user.name} ${data.user.surname}',
//                             description: data.user.email!,
//                             imageUrl: data.user.image!,
//                             uid: data.user.uid,
//                             lastMessage: lastMessage,
//                             notReadMessageCount: count,
//                             onTap: () async {
//                               Navigator.push(
//                                 context,
//                                 ConnectChatScreen.route(
//                                   userEntity: widget.userEntity,
//                                   targetUser: data.user,
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 );
//               }
//               if (state is ChatListFailure) {
//                 return Center(
//                   child: Text(state.message),
//                 );
//               }
//               return Text(
//                 state.toString(),
//               );
//             },
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           elevation: 0,
//           onPressed: () {
//             BlocProvider.of<UserCubit>(context).searchByName(
//               name: controllerSearch.text.trim(),
//             );
//           },
//           child: const Icon(
//             Icons.search,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
