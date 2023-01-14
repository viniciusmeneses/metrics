import "@fontsource/inter/400.css";
import "@fontsource/inter/500.css";
import "@fontsource/inter/600.css";
import "@fontsource/inter/700.css";

import { extendTheme, withDefaultColorScheme } from "@chakra-ui/react";

const theme = extendTheme(
  {
    colors: {
      primary: {
        50: "#fef5f7",
        100: "#fbd7df",
        200: "#f7b4c2",
        300: "#f1859c",
        400: "#ee6883",
        500: "#e8355a",
        600: "#cf173d",
        700: "#a81231",
        800: "#8f102a",
        900: "#690b1f",
      },
      gray: {
        50: "#fafafa",
        100: "#f1f1f1",
        200: "#e7e7e7",
        300: "#d4d4d4",
        400: "#adadad",
        500: "#7f7f7f",
        600: "#545454",
        700: "#373737",
        800: "#202020",
        900: "#191919",
      },
    },
    fonts: {
      body: "Inter, sans-serif",
      heading: "Inter, sans-serif",
    },
    shadows: {
      outline: "0 0 0 3px rgb(229, 25, 67, 0.3)",
    },
    components: {
      Button: {
        variants: {
          outline: {
            color: "primary.500",
          },
        },
      },
      Input: {
        defaultProps: {
          focusBorderColor: "primary.500",
        },
      },
      NumberInput: {
        defaultProps: {
          focusBorderColor: "primary.500",
        },
      },
      Select: {
        defaultProps: {
          focusBorderColor: "primary.500",
        },
      },
    },
  },
  withDefaultColorScheme({ colorScheme: "primary" }),
);

export { theme };
