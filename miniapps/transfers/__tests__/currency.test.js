import { convert, formatAmount } from '../src/lib/currency';

describe('convert', () => {
  test('applies the rate and rounds to cents', () => {
    expect(convert(10000, 1.25)).toBe(12500);
  });

  test('rounds fractional cents to the nearest cent', () => {
    expect(convert(333, 1.5)).toBe(500);
  });

  test('throws on a non-positive rate', () => {
    expect(() => convert(10000, 0)).toThrow('invalid rate: 0');
  });
});

describe('formatAmount', () => {
  test('renders amount with currency code', () => {
    expect(formatAmount(12500, 'USD')).toBe('125.00 USD');
  });
});
