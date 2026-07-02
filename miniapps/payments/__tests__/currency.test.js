import { parseAmount, formatUSD } from '../src/lib/currency';

describe('parseAmount', () => {
  test('converts dollars to integer cents', () => {
    expect(parseAmount('12.34')).toBe(1234);
  });

  test('rounds to the nearest cent', () => {
    expect(parseAmount('0.005')).toBe(1);
  });

  test('handles whole dollars', () => {
    expect(parseAmount('40')).toBe(4000);
  });

  test('throws on non-numeric input', () => {
    expect(() => parseAmount('abc')).toThrow('invalid amount: abc');
  });
});

describe('formatUSD', () => {
  test('formats cents as a dollar string', () => {
    expect(formatUSD(1234)).toBe('$12.34');
  });

  test('always shows two decimal places', () => {
    expect(formatUSD(4000)).toBe('$40.00');
  });

  test('renders negative amounts with a leading minus', () => {
    expect(formatUSD(-500)).toBe('-$5.00');
  });
});
