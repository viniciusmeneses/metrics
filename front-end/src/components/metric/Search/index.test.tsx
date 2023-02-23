import { screen } from "@testing-library/react";

import { render } from "../../../testUtils";

import { Search } from ".";

describe("Search", () => {
  it("renders metric name input", () => {
    render(<Search />);
    const input = screen.getByRole("textbox", { name: "Metric name" });
    expect(input).toBeInTheDocument();
  });

  it("renders grouping select", () => {
    render(<Search />);
    const select = screen.getByRole("combobox", { name: "Grouping" });
    expect(select).toBeInTheDocument();
  });

  it("renders grouping options", () => {
    render(<Search />);
    const options = screen.getAllByRole("option").map((el) => el.textContent);
    expect(options).toEqual(["By day", "By hour", "By minute"]);
  });
});
