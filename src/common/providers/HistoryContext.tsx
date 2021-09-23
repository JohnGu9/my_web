import { createBrowserHistory } from 'history';
import React from 'react';

export const history = createBrowserHistory();
export type HistoryContextType = typeof history;
export const HistoryContext = React.createContext(history);
