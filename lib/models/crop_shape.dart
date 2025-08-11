enum CropShape {
  circle('Circle', '●', 'Perfect circular crops'),
  square('Square', '■', 'Clean square crops'),
  heart('Heart', '♥', 'Romantic heart shapes'),
  star('Star', '★', 'Eye-catching 5-pointed stars'),
  hexagon('Hexagon', '⬢', 'Modern geometric hexagons'),
  diamond('Diamond', '♦', 'Elegant diamond cuts');

  const CropShape(this.displayName, this.icon, this.description);

  final String displayName;
  final String icon;
  final String description;
}
