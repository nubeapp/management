import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';

class TicketStatusDropdown extends StatefulWidget {
  const TicketStatusDropdown({super.key, this.onStatusSelected});

  final Function(String)? onStatusSelected;

  @override
  State<TicketStatusDropdown> createState() => _TicketStatusDropdownState();
}

class _TicketStatusDropdownState extends State<TicketStatusDropdown> {
  final List<String> _ticketStatusList = [
    'ALL',
    TicketStatus.AVAILABLE.name,
    TicketStatus.SOLD.name,
    TicketStatus.CANCELED.name,
    TicketStatus.VALIDATED.name,
  ];
  String _selectedOption = 'ALL';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedOption,
      onChanged: (newValue) {
        setState(() {
          _selectedOption = newValue!;
        });
        widget.onStatusSelected!(newValue!);
      },
      items: _ticketStatusList.map(
        (status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status),
          );
        },
      ).toList(),
      isExpanded: true,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w500,
      ),
      borderRadius: BorderRadius.circular(15),
      icon: const Icon(CupertinoIcons.chevron_down),
      iconSize: 20,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 17, bottom: 17, left: 15, right: 15),
        hintText: 'ALL',
        hintStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.7,
          color: Colors.black.withOpacity(0.3),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 240, 240),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
