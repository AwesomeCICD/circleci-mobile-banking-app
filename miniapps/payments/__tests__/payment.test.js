import { buildPayment, summarizePayment } from '../src/lib/payment';

describe('buildPayment', () => {
  test('assembles amount, fee, total and masked card', () => {
    const payment = buildPayment({ amountCents: 10000, cardNumber: '4242424242424242' });
    expect(payment).toEqual({
      amountCents: 10000,
      feeCents: 320,
      totalCents: 10320,
      card: '•••• 4242',
    });
  });

  test('throws on an invalid card number', () => {
    expect(() => buildPayment({ amountCents: 10000, cardNumber: '4242424242424241' })).toThrow(
      'invalid card number',
    );
  });
});

describe('summarizePayment', () => {
  test('renders a human-readable summary line', () => {
    const payment = buildPayment({ amountCents: 10000, cardNumber: '4242424242424242' });
    expect(summarizePayment(payment)).toBe('•••• 4242 — $103.20 (incl. $3.20 fee)');
  });
});
