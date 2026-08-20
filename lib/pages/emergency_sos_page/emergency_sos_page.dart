import 'package:flutter/material.dart';

class EmergencySosWidget extends StatelessWidget {
  const EmergencySosWidget({super.key});

  // Static emergency contact data.
  static const List<Map<String, dynamic>> emergencyContacts = [
    {
      'name': 'Rohit Sharma',
      'phone': '+91 98765 43210',
      'color': Color(0xFF16A34A),
    },
    {
      'name': 'Priya Sharma',
      'phone': '+91 91234 56789',
      'color': Color(0xFFF59E0B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
    SafeArea(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF080808),
          gradient: RadialGradient(
            center: Alignment(0.0, -0.15),
            radius: 0.95,
            colors: [
              Color(0xFF5A0808),
              Color(0xFF260505),
              Color(0xFF100303),
              Color(0xFF080808),
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -----------------------------------------------------------
              // Header
              // -----------------------------------------------------------
              const Text(
                'Emergency SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 34),

              // -----------------------------------------------------------
              // SOS Button with concentric glowing pulse rings
              // -----------------------------------------------------------
              Center(
                child: SizedBox(
                  width: 285,
                  height: 285,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer pulse ring.
                      Container(
                        width: 275,
                        height: 275,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF1F1F).withOpacity(0.035),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF1717).withOpacity(0.10),
                              blurRadius: 55,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                      ),

                      // Middle pulse ring.
                      Container(
                        width: 225,
                        height: 225,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF1F1F).withOpacity(0.07),
                          border: Border.all(
                            color: const Color(0xFFFF3333).withOpacity(0.10),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF1515).withOpacity(0.14),
                              blurRadius: 35,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),

                      // Inner pulse ring.
                      Container(
                        width: 195,
                        height: 195,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF1F1F).withOpacity(0.10),
                          border: Border.all(
                            color: const Color(0xFFFF3838).withOpacity(0.16),
                            width: 1,
                          ),
                        ),
                      ),

                      // Main SOS button.
                      Container(
                        width: 166,
                        height: 166,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE50914),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF1010).withOpacity(0.45),
                              blurRadius: 35,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: const Color(0xFFFF2020).withOpacity(0.22),
                              blurRadius: 70,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'SOS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // -----------------------------------------------------------
              // SOS Description
              // -----------------------------------------------------------
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    'Your location & alert will be sent to emergency '
                    'contacts and support team.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB8B8B8),
                      fontSize: 14,
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // -----------------------------------------------------------
              // Road Assistance Button
              // -----------------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Trigger road assistance request.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: const Color(0xFFE50914).withOpacity(0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'CALL ROAD ASSISTANCE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // -----------------------------------------------------------
              // Emergency Contacts Section
              // -----------------------------------------------------------
              const Text(
                'Emergency Contacts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 14),

              // Contacts card.
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF151515).withOpacity(0.92),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: const Color(0xFF303030),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildContactRow(
                      contact: emergencyContacts[0],
                      showDivider: true,
                    ),
                    _buildContactRow(
                      contact: emergencyContacts[1],
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
,);
  
  }

  // -------------------------------------------------------------
  // Emergency contact row
  // -------------------------------------------------------------
  Widget _buildContactRow({
    required Map<String, dynamic> contact,
    required bool showDivider,
  }) {
    final Color avatarColor = contact['color'] as Color;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Row(
            children: [
              // Contact avatar.
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: avatarColor.withOpacity(0.18),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: avatarColor,
                  size: 26,
                ),
              ),

              const SizedBox(width: 13),

              // Contact name and phone number.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      contact['phone'] as String,
                      style: const TextStyle(
                        color: Color(0xFF929292),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Call button.
              Material(
                color: const Color(0xFF16A34A),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    // TODO: Implement phone call.
                  },
                  child: const SizedBox(
                    width: 43,
                    height: 43,
                    child: Icon(
                      Icons.call_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Divider between contacts.
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 76, right: 15),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFF2A2A2A),
            ),
          ),
      ],
    );
  }
}