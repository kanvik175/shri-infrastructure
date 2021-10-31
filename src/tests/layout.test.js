import React from 'react';
import { render } from '@testing-library/react';
import App from '../App';


it('есть ссылка', () => {
  const { getByRole } = render(<App />);

  expect(getByRole('link', { name: /learn react/i })).toBeInTheDocument();
})

it('есть лого', () => {
  const { getByAltText } = render(<App />);

  expect(getByAltText('logo')).toBeInTheDocument();
})