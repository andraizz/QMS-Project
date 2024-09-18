part of 'ticket_by_user_bloc.dart';

@immutable
sealed class TicketByUserEvent {}

class FetchTicketByUserCM extends TicketByUserEvent {}

class FetchTicketByUserPM extends TicketByUserEvent {}

