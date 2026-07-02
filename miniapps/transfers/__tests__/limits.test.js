import { remainingLimit, withinDailyLimit } from '../src/lib/limits';

describe('remainingLimit', () => {
  test('returns the unused portion of the limit', () => {
    expect(remainingLimit(3000, 10000)).toBe(7000);
  });

  test('never goes negative', () => {
    expect(remainingLimit(12000, 10000)).toBe(0);
  });
});

describe('withinDailyLimit', () => {
  test('allows a transfer that fits under the limit', () => {
    expect(withinDailyLimit(5000, 3000, 10000)).toBe(true);
  });

  test('allows a transfer that exactly reaches the limit', () => {
    expect(withinDailyLimit(7000, 3000, 10000)).toBe(true);
  });

  test('rejects a transfer that exceeds the limit', () => {
    expect(withinDailyLimit(8000, 3000, 10000)).toBe(false);
  });
});
