import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders learn react link', () => {
  render(<App />);
  {
    const element = screen.getByText(/Flutter/i);
    expect(element).toBeInTheDocument();
  }
  {
    const element = screen.getByText(/React/i);
    expect(element).toBeInTheDocument();
  }
});
