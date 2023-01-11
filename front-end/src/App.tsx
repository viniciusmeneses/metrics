import { ChakraProvider, Text, theme } from "@chakra-ui/react";

export const App = () => (
  <ChakraProvider theme={theme}>
    <Text>Chakra UI</Text>
  </ChakraProvider>
);
