import React from "react";
import { StorageContext } from "./StorageContext";

const english = {
  signIn: 'Sign in',
  signOut: 'Sign out',
  next: 'Next',
  help: 'Help',
  username: 'Username',
  password: 'Password',
  ok: 'OK',
  cancel: 'Cancel'
};

const chineseSimplified = {
  ...english,
  signIn: '登录',
  signOut: '登出',
  next: '下一步',
  help: '帮助',
  username: '用户名',
  password: '密码',
  ok: '好的',
  cancel: '取消',
};

const defaultLocale = {
  name: 'English',
  locale: english,
  toggle: (_: string) => { }
}
export const LocaleContext = React.createContext(defaultLocale);

export function LocaleService(props: { children: React.ReactNode }) {
  return (
    <StorageContext.Consumer>
      {storage => (
        <LocaleService.Service storage={storage}>
          {props.children}
        </LocaleService.Service>
      )}
    </StorageContext.Consumer>
  );
}

export namespace LocaleService {
  const locales = [
    "af", "sq", "ar-SA", "ar-IQ", "ar-EG", "ar-LY", "ar-DZ", "ar-MA", "ar-TN", "ar-OM",
    "ar-YE", "ar-SY", "ar-JO", "ar-LB", "ar-KW", "ar-AE", "ar-BH", "ar-QA", "eu", "bg",
    "be", "ca", "zh-TW", "zh-CN", "zh-HK", "zh-SG", "hr", "cs", "da", "nl", "nl-BE", "en",
    "en-US", "en-EG", "en-AU", "en-GB", "en-CA", "en-NZ", "en-IE", "en-ZA", "en-JM",
    "en-BZ", "en-TT", "et", "fo", "fa", "fi", "fr", "fr-BE", "fr-CA", "fr-CH", "fr-LU",
    "gd", "gd-IE", "de", "de-CH", "de-AT", "de-LU", "de-LI", "el", "he", "hi", "hu",
    "is", "id", "it", "it-CH", "ja", "ko", "lv", "lt", "mk", "mt", "no", "pl",
    "pt-BR", "pt", "rm", "ro", "ro-MO", "ru", "ru-MI", "sz", "sr", "sk", "sl", "sb",
    "es", "es-AR", "es-GT", "es-CR", "es-PA", "es-DO", "es-MX", "es-VE", "es-CO",
    "es-PE", "es-EC", "es-CL", "es-UY", "es-PY", "es-BO", "es-SV", "es-HN", "es-NI",
    "es-PR", "sx", "sv", "sv-FI", "th", "ts", "tn", "tr", "uk", "ur", "ve", "vi", "xh",
    "ji", "zu"];

  function buildState(locale: string) {
    switch (locale) {
      case 'zh-CN':
        return {
          name: 'Chinese (Simplified)',
          locale: chineseSimplified,
        };
      default:
        return {
          name: 'English',
          locale: english,
        };
    }
  }

  export class Service extends React.Component<Service.Props, Service.State> {
    constructor(props: Service.Props) {
      super(props);
      const currentLocale = props.storage.localStorage.getItem('locale') || window.navigator.language;
      const toggle = (newLocale: string) => {
        if (locales.includes(newLocale)) {
          this.props.storage.localStorage.setItem('locale', newLocale);
          this.setState(buildState(newLocale));
        }
      }
      this.state = {
        ...buildState(currentLocale),
        toggle: toggle,
      }
    }

    render() {
      return (
        <LocaleContext.Provider value={this.state}>
          {this.props.children}
        </LocaleContext.Provider>
      );
    }
  }

  namespace Service {
    export type Props = {
      children: React.ReactNode, storage: {
        localStorage: Storage,
        sessionStorage: Storage,
      }
    }
    export type State = typeof defaultLocale
  }
}