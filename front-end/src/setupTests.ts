import "@testing-library/jest-dom";

import { queryClient } from "./api";
import { server } from "./mocks";

beforeAll(() => server.listen());
beforeEach(() => queryClient.clear());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
