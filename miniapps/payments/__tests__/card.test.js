import { luhnValid, maskCard } from '../src/lib/card';

describe('luhnValid', () => {
  test('accepts a valid Visa test number', () => {
    expect(luhnValid('4242424242424242')).toBe(true);
  });

  test('accepts numbers with spaces', () => {
    expect(luhnValid('4242 4242 4242 4242')).toBe(true);
  });

  test('rejects a number that fails the checksum', () => {
    expect(luhnValid('4242424242424241')).toBe(false);
  });

  test('rejects non-digit input', () => {
    expect(luhnValid('not-a-card')).toBe(false);
  });

  test('rejects numbers that are too short', () => {
    expect(luhnValid('4242')).toBe(false);
  });
});

describe('maskCard', () => {
  test('shows only the last four digits', () => {
    expect(maskCard('4242424242424242')).toBe('•••• 4242');
  });

  test('strips spaces before masking', () => {
    expect(maskCard('4242 4242 4242 1234')).toBe('•••• 1234');
  });
});
