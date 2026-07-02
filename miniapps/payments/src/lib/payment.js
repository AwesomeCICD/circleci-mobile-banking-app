import { formatUSD } from './currency';
import { cardFeeCents, totalWithFee } from './fees';
import { luhnValid, maskCard } from './card';

// Assembles a payment from a raw amount + card number, applying the
// processing fee and masking the card for display.
export function buildPayment({ amountCents, cardNumber }) {
  if (!luhnValid(cardNumber)) {
    throw new Error('invalid card number');
  }
  return {
    amountCents,
    feeCents: cardFeeCents(amountCents),
    totalCents: totalWithFee(amountCents),
    card: maskCard(cardNumber),
  };
}

export function summarizePayment(payment) {
  return `${payment.card} — ${formatUSD(payment.totalCents)} (incl. ${formatUSD(payment.feeCents)} fee)`;
}
