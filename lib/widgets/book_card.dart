import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';

/// A book-shaped class card, fully widget-built (replaces the `background.jpg`
/// image card). It has a left spine, a gradient cover, stacked "page" edges on
/// the right, and an optional delete affordance for teachers. Wrapped in a
/// [Hero] (tag = classId) for a shared-element transition into the class page.
class BookCard extends StatefulWidget {
  final String className;
  final String teacher;
  final String branch;
  final String year;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final int index;

  const BookCard({
    super.key,
    required this.className,
    required this.teacher,
    required this.branch,
    required this.year,
    required this.heroTag,
    required this.onTap,
    this.onDelete,
    this.index = 0,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final gradient = AppColors.bookGradientFor(widget.className);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Hero(
            tag: widget.heroTag,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                height: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Page edges peeking out on the right of the spine.
                    _PageEdges(color: gradient.last),
                    // Book cover.
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradient.last.withValues(alpha: 0.45),
                              blurRadius: 18,
                              offset: const Offset(4, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Spine highlight line.
                            Positioned(
                              left: 8,
                              top: 10,
                              bottom: 10,
                              child: Container(
                                width: 2,
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 18, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.bookOpen,
                                    color: Colors.white.withValues(alpha: 0.85),
                                    size: 22,
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.className,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.chalkboardUser,
                                        color: Colors.white
                                            .withValues(alpha: 0.8),
                                        size: 12,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          widget.teacher,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.85),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      if (widget.branch.isNotEmpty)
                                        _Chip(label: widget.branch),
                                      if (widget.year.isNotEmpty)
                                        _Chip(label: 'Year ${widget.year}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (widget.onDelete != null)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.trashCan,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  onPressed: widget.onDelete,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageEdges extends StatelessWidget {
  final Color color;
  const _PageEdges({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.55),
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(-1, 2),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
