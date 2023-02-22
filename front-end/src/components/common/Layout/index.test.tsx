import { screen } from "@testing-library/react";

import { render } from "../../../testUtils";

import { Layout } from ".";

describe("Layout", () => {
  it("renders main page content", () => {
    render(
      <Layout>
        <p>Sample</p>
      </Layout>,
    );
    const page = screen.getByRole("main");
    expect(page).toBeInTheDocument();
  });
});
