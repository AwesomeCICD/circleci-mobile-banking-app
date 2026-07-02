// Daily transfer limit checks, all in integer cents.

export function remainingLimit(spentCents, limitCents) {
  return Math.max(0, limitCents - spentCents);
}

export function withinDailyLimit(amountCents, spentCents, limitCents) {
  return spentCents + amountCents <= limitCents;
}
