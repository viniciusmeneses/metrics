import { forwardRef } from "react";
import MaskedInput, { MaskedInputProps } from "react-text-mask";
import { createNumberMask } from "text-mask-addons";

import { Input } from "@chakra-ui/react";

const mask = createNumberMask({
  prefix: "",
  allowDecimal: true,
  decimalSymbol: ",",
  thousandsSeparatorSymbol: ".",
});

export const NumberInput = forwardRef((props: Omit<MaskedInputProps, "mask">, ref) => (
  <MaskedInput
    mask={mask}
    render={(maskedInputRef, props) => (
      <Input
        ref={(inputRef: HTMLInputElement) => {
          maskedInputRef(inputRef);
          typeof ref === "function" && ref(inputRef);
        }}
        {...props}
      />
    )}
    {...props}
  />
));
