// Amounts are integer minor units (cents). Conversion takes a decimal rate.

export function convert(amountCents, rate) {
  if (!(rate > 0)) {
    throw new Error(`invalid rate: ${rate}`);
  }
  return Math.round(amountCents * rate);
}

export function formatAmount(amountCents, currency) {
  const major = (amountCents / 100).toFixed(2);
  return `${major} ${currency}`;
}
