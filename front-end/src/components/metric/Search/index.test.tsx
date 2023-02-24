import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import * as metric from "../../../models/metric";
import { render } from "../../../testUtils";

import { Search } from ".";

const mockSetName = jest.fn();
const mockSetGroupBy = jest.fn();

jest.mock("../../../models/metric", () => ({
  useSearchMetrics: () => ({
    name: "",
    groupBy: "day",
    setName: mockSetName,
    setGroupBy: mockSetGroupBy,
  }),
}));

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

  describe("when type name", () => {
    it("sets the value", async () => {
      render(<Search />);
      const input = screen.getByRole("textbox", { name: "Metric name" });
      await userEvent.type(input, "a");
      expect(mockSetName).toHaveBeenCalledWith("a");
    });
  });

  describe("when select grouping", () => {
    it("sets the value", async () => {
      render(<Search />);
      const select = screen.getByRole("combobox", { name: "Grouping" });
      await userEvent.selectOptions(select, "hour");
      expect(mockSetGroupBy).toHaveBeenCalledWith("hour");
    });
  });
});
