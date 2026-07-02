import { buildTransfer, transferSummary } from '../src/lib/transfer';

const base = {
  toIban: 'GB82 WEST 1234 5698 7654 32',
  amountCents: 5000,
  currency: 'USD',
  spentCents: 3000,
  limitCents: 10000,
};

describe('buildTransfer', () => {
  test('builds a validated transfer with a formatted IBAN', () => {
    expect(buildTransfer(base)).toEqual({
      toIban: 'GB82 WEST 1234 5698 7654 32',
      amountCents: 5000,
      currency: 'USD',
    });
  });

  test('throws on an invalid destination IBAN', () => {
    expect(() => buildTransfer({ ...base, toIban: 'GB82' })).toThrow('invalid destination IBAN');
  });

  test('throws when the daily limit is exceeded', () => {
    expect(() => buildTransfer({ ...base, amountCents: 8000 })).toThrow(
      'daily transfer limit exceeded',
    );
  });
});

describe('transferSummary', () => {
  test('renders a human-readable summary line', () => {
    expect(transferSummary(buildTransfer(base))).toBe('50.00 USD → GB82 WEST 1234 5698 7654 32');
  });
});
