import { Controller } from "react-hook-form";

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
  VStack,
} from "@chakra-ui/react";

import { NumberInput } from "../../form";

import { useCreateRecordForm } from "./form";

interface Props {
  metricId: number;
}

export const CreateRecordModal = ({ metricId, ...props }: Omit<ModalProps, "children"> & Props) => {
  const {
    formState: { errors, isSubmitting },
    control,
    register,
    onSubmit,
    reset,
  } = useCreateRecordForm({ metricId, onSuccess: props.onClose });

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
          <ModalHeader>Add record</ModalHeader>

          <ModalBody pb={6}>
            <VStack spacing={4}>
              <FormControl isInvalid={Boolean(errors.timestamp)} isRequired>
                <FormLabel>Date and time</FormLabel>
                <Input type="datetime-local" step={1} {...register("timestamp")} />
                {errors.timestamp && (
                  <FormErrorMessage>{errors.timestamp.message}</FormErrorMessage>
                )}
              </FormControl>

              <FormControl isInvalid={Boolean(errors.value)} isRequired>
                <FormLabel>Value</FormLabel>
                <Controller
                  name="value"
                  control={control}
                  render={({ field }) => <NumberInput {...field} />}
                />
                {errors.value && <FormErrorMessage>{errors.value.message}</FormErrorMessage>}
              </FormControl>
            </VStack>
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
              Add
            </Button>
          </ModalFooter>
        </chakra.form>
      </ModalContent>
    </Modal>
  );
};
