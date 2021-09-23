import { ThemeProvider } from "rmwc";
import React from "react";

export type ThemeData = typeof themes.lightTheme;

const themes = {
  lightTheme: {
    primary: '#6200ee',
    secondary: '#03dac4',
    error: '#b00020',
    background: '#fff',
    surface: '#fff',
    onPrimary: 'rgba(255, 255, 255, 1)',
    onSecondary: 'rgba(0, 0, 0, 0.87)',
    onSurface: 'rgba(0, 0, 0, 0.87)',
    onError: '#fff',
    textPrimaryOnBackground: 'rgba(0, 0, 0, 0.87)',
    textSecondaryOnBackground: 'rgba(0, 0, 0, 0.54)',
    textHintOnBackground: 'rgba(0, 0, 0, 0.38)',
    textDisabledOnBackground: 'rgba(0, 0, 0, 0.38)',
    textIconOnBackground: 'rgba(0, 0, 0, 0.38)',
    textPrimaryOnLight: 'rgba(0, 0, 0, 0.87)',
    textSecondaryOnLight: 'rgba(0, 0, 0, 0.54)',
    textHintOnLight: 'rgba(0, 0, 0, 0.38)',
    textDisabledOnLight: 'rgba(0, 0, 0, 0.38)',
    textIconOnLight: 'rgba(0, 0, 0, 0.38)',
    textPrimaryOnDark: 'white',
    textSecondaryOnDark: 'rgba(255, 255, 255, 0.7)',
    textHintOnDark: 'rgba(255, 255, 255, 0.5)',
    textDisabledOnDark: 'rgba(255, 255, 255, 0.5)',
    textIconOnDark: 'rgba(255, 255, 255, 0.5)'
  },
  darkTheme: {
    primary: '#bb86fc',
    secondary: '#03dac5',
    error: '#FF5252',
    background: '#303030',
    surface: '#37474F',
    onPrimary: 'rgba(0,0,0,0.87)',
    onSecondary: 'rgba(0,0,0,0.87)',
    onSurface: 'rgba(255,255,255,.87)',
    onError: '#fff',
    textPrimaryOnBackground: 'rgba(255, 255, 255, 1)',
    textSecondaryOnBackground: 'rgba(255, 255, 255, 0.7)',
    textHintOnBackground: 'rgba(255, 255, 255, 0.5)',
    textDisabledOnBackground: 'rgba(255, 255, 255, 0.5)',
    textIconOnBackground: 'rgba(255, 255, 255, 0.5)',
    textPrimaryOnLight: 'rgba(0, 0, 0, 0.87)',
    textSecondaryOnLight: 'rgba(0, 0, 0, 0.54)',
    textHintOnLight: 'rgba(0, 0, 0, 0.38)',
    textDisabledOnLight: 'rgba(0, 0, 0, 0.38)',
    textIconOnLight: 'rgba(0, 0, 0, 0.38)',
    textPrimaryOnDark: 'white',
    textSecondaryOnDark: 'rgba(255, 255, 255, 0.7)',
    textHintOnDark: 'rgba(255, 255, 255, 0.5)',
    textDisabledOnDark: 'rgba(255, 255, 255, 0.5)',
    textIconOnDark: 'rgba(255, 255, 255, 0.5)'
  }
}

export const ThemeContext = React.createContext<ThemeService.State>({ themeData: themes.lightTheme });

export class ThemeService extends React.Component<ThemeService.Props, ThemeService.State> {
  constructor(props: ThemeService.Props) {
    super(props);
    this._listener = this._listener.bind(this);
    this._mediaQueryList = window.matchMedia('(prefers-color-scheme: dark)');
    this.state = { themeData: this.isDark ? themes.darkTheme : themes.lightTheme }
  }
  _mediaQueryList: MediaQueryList;
  get isDark() { return this._mediaQueryList.matches }

  _listener(event: MediaQueryListEvent) {
    this.setState({ themeData: this.isDark ? themes.darkTheme : themes.lightTheme });
  }

  componentDidMount() {
    this._mediaQueryList.addEventListener('change', this._listener);
  }

  componentWillUnmount() {
    this._mediaQueryList.removeEventListener('change', this._listener);
  }

  render() {
    return (
      <ThemeContext.Provider value={this.state}>
        <ThemeProvider options={this.state.themeData} style={{ height: '100%', width: '100%' }}>
          {this.props.children}
        </ThemeProvider>
      </ThemeContext.Provider>
    );
  }
}

namespace ThemeService {
  export type Props = { children: React.ReactNode }
  export type State = { themeData: ThemeData }
}