import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import { render } from "../../../testUtils";

import { Header } from ".";

describe("Header", () => {
  it("renders title", () => {
    render(<Header />);
    const title = screen.getByText("Metrics");
    expect(title).toBeInTheDocument();
  });

  it("renders description", () => {
    render(<Header />);
    const description = screen.getByText("Analyze your metrics with a user-friendly dashboard");
    expect(description).toBeInTheDocument();
  });

  describe("when click on create metric button", () => {
    it("opens a modal", async () => {
      render(<Header />);

      const button = screen.getByRole("button", { name: "Create metric" });
      await userEvent.click(button);

      const modal = screen.getByRole("dialog");

      expect(modal).toBeInTheDocument();
    });
  });
});
