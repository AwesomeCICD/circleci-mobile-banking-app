import { ibanValid, formatIban } from './iban';
import { formatAmount } from './currency';
import { withinDailyLimit } from './limits';

// Builds a validated transfer, enforcing IBAN validity and the daily limit.
export function buildTransfer({ toIban, amountCents, currency, spentCents, limitCents }) {
  if (!ibanValid(toIban)) {
    throw new Error('invalid destination IBAN');
  }
  if (!withinDailyLimit(amountCents, spentCents, limitCents)) {
    throw new Error('daily transfer limit exceeded');
  }
  return {
    toIban: formatIban(toIban),
    amountCents,
    currency,
  };
}

export function transferSummary(transfer) {
  return `${formatAmount(transfer.amountCents, transfer.currency)} → ${transfer.toIban}`;
}
