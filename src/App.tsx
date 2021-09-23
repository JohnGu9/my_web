import HomePage from './pages/HomePage';
import { Router } from 'react-router-dom';
import { ThemeService, history, StorageContext } from './common/Providers';

function App() {
  return (
    <Router history={history}>
      <StorageContext.Provider value={{
        localStorage: localStorage,
        sessionStorage: sessionStorage,
      }}>
        <ThemeService>
          <HomePage />
        </ThemeService>
      </StorageContext.Provider>
    </Router>
  );
}

export default App;
