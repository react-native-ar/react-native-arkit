// Unique id generator

export default function() {
  const firstEightDigits = Math.random().toString(36).substr(2, 8);
  const secondEightDigits = Math.random().toString(36).substr(2, 8);
  return `${firstEightDigits}${secondEightDigits}`;
}
