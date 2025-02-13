import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> continents;
  final List<String> timezones;
  final Set<String> selectedContinents;
  final Set<String> selectedTimezones;
  final Function(Set<String>, Set<String>) onApply;

  const FilterBottomSheet({
    super.key,
    required this.continents,
    required this.timezones,
    required this.selectedContinents,
    required this.selectedTimezones,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<String> _tempContinents;
  late Set<String> _tempTimezones;
  List<bool> _isExpanded = [false, false];

  @override
  void initState() {
    super.initState();
    _tempContinents = {...widget.selectedContinents};
    _tempTimezones = {...widget.selectedTimezones};
    _isExpanded = [false, false];
  }

  @override
// Builds the filter bottom sheet widget that allows users to select continents and time zones.
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (index, isExpanded) {
                setState(() {
                  _isExpanded[index] = !_isExpanded[index];
                });
              },
              children: [
                _buildContinentPanel(),
                _buildTimezonePanel(),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // Builds an expansion panel that shows a list of all continents.
  ExpansionPanel _buildContinentPanel() {
    return ExpansionPanel(
      headerBuilder: (context, isExpanded) => ListTile(
        title: const Text('Continents'),
        onTap: () => setState(() => _isExpanded[0] = !_isExpanded[0]),
      ),
      body: Column(
        children: widget.continents
            .map((continent) => FilterCheckbox(
                  title: continent,
                  isSelected: _tempContinents.contains(continent),
                  onChanged: (selected) {
                    setState(() {
                      selected
                          ? _tempContinents.add(continent)
                          : _tempContinents.remove(continent);
                    });
                  },
                ))
            .toList(),
      ),
      isExpanded: _isExpanded[0],
    );
  }

  // Builds an expansion panel that shows a list of all time zones.
  ExpansionPanel _buildTimezonePanel() {
    return ExpansionPanel(
      headerBuilder: (context, isExpanded) => ListTile(
        title: const Text('Time Zones'),
        onTap: () => setState(() => _isExpanded[1] = !_isExpanded[1]),
      ),
      body: Column(
        children: widget.timezones
            .map((tz) => FilterCheckbox(
                  title: tz,
                  isSelected: _tempTimezones.contains(tz),
                  onChanged: (selected) {
                    setState(() {
                      selected
                          ? _tempTimezones.add(tz)
                          : _tempTimezones.remove(tz);
                    });
                  },
                ))
            .toList(),
      ),
      isExpanded: _isExpanded[1],
    );
  }

  //Builds the action buttons for the filter bottom sheet.
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(side: BorderSide(width: 0.5))),
            onPressed: () {
              setState(() {
                _tempContinents.clear();
                _tempTimezones.clear();
              });
            },
            child: const Text('Reset'),
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromRGBO(255, 108, 0, 0.8),
                shape: RoundedRectangleBorder()),
            onPressed: () {
              widget.onApply(_tempContinents, _tempTimezones);
              Navigator.pop(context);
            },
            child: const Text(
              'Show Results',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterCheckbox extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function(bool) onChanged;

  const FilterCheckbox({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: isSelected,
      onChanged: (value) => onChanged(value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
