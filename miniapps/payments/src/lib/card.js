// Basic card-number helpers: Luhn checksum validation and display masking.

export function luhnValid(number) {
  const digits = String(number).replace(/\s+/g, '');
  if (!/^\d{12,19}$/.test(digits)) {
    return false;
  }
  let sum = 0;
  let double = false;
  for (let i = digits.length - 1; i >= 0; i--) {
    let d = Number(digits[i]);
    if (double) {
      d *= 2;
      if (d > 9) {
        d -= 9;
      }
    }
    sum += d;
    double = !double;
  }
  return sum % 10 === 0;
}

export function maskCard(number) {
  const digits = String(number).replace(/\s+/g, '');
  return `•••• ${digits.slice(-4)}`;
}
