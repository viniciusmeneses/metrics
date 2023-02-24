import { screen } from "@testing-library/react";

import { render } from "../../testUtils";

import { Home } from ".";

jest.mock("react-apexcharts");

describe("Home", () => {
  it("renders header", () => {
    render(<Home />);
    const header = screen.getByRole("heading", { name: "Metrics" });
    expect(header).toBeInTheDocument();
  });

  it("renders search fields", () => {
    render(<Home />);

    const nameInput = screen.getByRole("textbox", { name: "Metric name" });
    const groupingSelect = screen.getByRole("combobox", { name: "Grouping" });

    expect(nameInput).toBeInTheDocument();
    expect(groupingSelect).toBeInTheDocument();
  });

  describe("when is loading", () => {
    it("renders a spinner", () => {
      render(<Home />);
      const spinner = screen.getByText("Loading...");
      expect(spinner).toBeInTheDocument();
    });
  });

  describe("when is not loading", () => {
    it("renders list of metrics", async () => {
      render(<Home />);
      const metrics = await screen.findAllByRole("article");
      expect(metrics).toHaveLength(2);
    });
  });
});
