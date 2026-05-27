import React from 'react';
import { render } from '@testing-library/react-native';
import App from '../src/App';

test('renders Transfers title', () => {
  const { getByText } = render(<App />);
  expect(getByText('Transfers')).toBeTruthy();
});
