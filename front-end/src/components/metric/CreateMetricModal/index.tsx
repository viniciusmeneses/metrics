import {
  Button,
  chakra,
  FormControl,
  FormErrorMessage,
  FormLabel,
  Input,
  Modal,
  ModalBody,
  ModalContent,
  ModalFooter,
  ModalHeader,
  ModalOverlay,
  ModalProps,
} from "@chakra-ui/react";

import { useCreateMetricForm } from "./form";

export const CreateMetricModal = (props: Omit<ModalProps, "children">) => {
  const {
    formState: { errors, isSubmitting },
    register,
    onSubmit,
    reset,
  } = useCreateMetricForm({ onSuccess: props.onClose });

  return (
    <Modal
      size={{ base: "full", sm: "sm" }}
      closeOnOverlayClick={false}
      onCloseComplete={reset}
      {...props}
    >
      <ModalOverlay />

      <ModalContent>
        <chakra.form display="flex" flexDirection="column" flex={1} onSubmit={onSubmit} noValidate>
          <ModalHeader>Create metric</ModalHeader>

          <ModalBody pb={6}>
            <FormControl isInvalid={Boolean(errors.name)} isRequired>
              <FormLabel>Name</FormLabel>
              <Input {...register("name")} />
              {errors.name && <FormErrorMessage>{errors.name.message}</FormErrorMessage>}
            </FormControl>
          </ModalBody>

          <ModalFooter>
            <Button
              onClick={props.onClose}
              variant="ghost"
              colorScheme="gray"
              mr={3}
              disabled={isSubmitting}
            >
              Cancel
            </Button>

            <Button w="100px" type="submit" isLoading={isSubmitting}>
              Create
            </Button>
          </ModalFooter>
        </chakra.form>
      </ModalContent>
    </Modal>
  );
};
