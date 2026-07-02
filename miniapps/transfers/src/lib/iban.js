// Lightweight IBAN helpers — normalisation and a structural validity check.

export function normalizeIban(input) {
  return String(input).replace(/\s+/g, '').toUpperCase();
}

export function ibanValid(input) {
  const iban = normalizeIban(input);
  return /^[A-Z]{2}\d{2}[A-Z0-9]{11,30}$/.test(iban);
}

export function formatIban(input) {
  const iban = normalizeIban(input);
  return iban.replace(/(.{4})/g, '$1 ').trim();
}
