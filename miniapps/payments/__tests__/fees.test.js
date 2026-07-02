import { cardFeeCents, totalWithFee } from '../src/lib/fees';

describe('cardFeeCents', () => {
  test('applies 2.9% plus a 30c flat fee', () => {
    expect(cardFeeCents(10000)).toBe(320);
  });

  test('is just the flat fee on a zero amount', () => {
    expect(cardFeeCents(0)).toBe(30);
  });

  test('rounds the percentage component to the nearest cent', () => {
    expect(cardFeeCents(105)).toBe(33);
  });
});

describe('totalWithFee', () => {
  test('adds the fee to the amount', () => {
    expect(totalWithFee(10000)).toBe(10320);
  });
});
