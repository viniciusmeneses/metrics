import { BrowserRouter, Routes } from "react-router-dom";
import { QueryParamProvider } from "use-query-params";
import { ReactRouter6Adapter } from "use-query-params/adapters/react-router-6";

import { ChakraProvider } from "@chakra-ui/react";

import { theme } from "./models/theme";
import { ApiProvider } from "./api";

export const App = () => (
  <ChakraProvider theme={theme} resetCSS>
    <ApiProvider>
      <BrowserRouter>
        <QueryParamProvider adapter={ReactRouter6Adapter}>
          <Routes />
        </QueryParamProvider>
      </BrowserRouter>
    </ApiProvider>
  </ChakraProvider>
);
