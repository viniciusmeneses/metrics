import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import { render } from "../../../testUtils";

import { NumberInput } from ".";

describe("NumberInput", () => {
  it("renders a text input", () => {
    render(<NumberInput />);
    const input = screen.getByRole("textbox");
    expect(input).toBeInTheDocument();
  });

  describe("when type the number 1500", () => {
    it("displays with correct mask", async () => {
      render(<NumberInput />);

      const input = screen.getByRole("textbox");
      await userEvent.type(input, "1500");

      expect(input).toHaveValue("1.500");
    });
  });

  describe("when type the number 3250,99", () => {
    it("displays with correct mask", async () => {
      render(<NumberInput />);

      const input = screen.getByRole("textbox");
      await userEvent.type(input, "3250,99");

      expect(input).toHaveValue("3.250,99");
    });
  });
});
