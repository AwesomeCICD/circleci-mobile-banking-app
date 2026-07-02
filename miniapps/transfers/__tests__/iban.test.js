import { normalizeIban, ibanValid, formatIban } from '../src/lib/iban';

describe('normalizeIban', () => {
  test('strips spaces and uppercases', () => {
    expect(normalizeIban('gb82 west 1234 5698 7654 32')).toBe('GB82WEST12345698765432');
  });
});

describe('ibanValid', () => {
  test('accepts a well-formed IBAN', () => {
    expect(ibanValid('GB82 WEST 1234 5698 7654 32')).toBe(true);
  });

  test('rejects an IBAN that is too short', () => {
    expect(ibanValid('GB82')).toBe(false);
  });

  test('rejects an IBAN without a country prefix', () => {
    expect(ibanValid('1234567890123456')).toBe(false);
  });
});

describe('formatIban', () => {
  test('groups digits into blocks of four', () => {
    expect(formatIban('GB82WEST12345698765432')).toBe('GB82 WEST 1234 5698 7654 32');
  });
});
