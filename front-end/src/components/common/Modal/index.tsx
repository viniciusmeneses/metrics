import { Modal as ChakraModal, ModalContent, ModalOverlay, ModalProps } from "@chakra-ui/react";

export const Modal = ({ children, ...props }: ModalProps) => (
  <ChakraModal size={{ base: "full", sm: "sm" }} closeOnOverlayClick={false} {...props}>
    <ModalOverlay />
    <ModalContent>{children}</ModalContent>
  </ChakraModal>
);
